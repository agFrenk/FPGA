--
-- Copyright (C) 2009-2012 Chris McClelland
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU Lesser General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU Lesser General Public License for more details.
--
-- You should have received a copy of the GNU Lesser General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
library ieee;
library comun;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use comun.funciones.all;

entity top_level is
	port(
		-- FX2LP interface ---------------------------------------------------------------------------
		fx2Clk_in      : in    std_logic;                    -- 48MHz clock from FX2LP
		fx2Addr_out    : out   std_logic_vector(1 downto 0); -- select FIFO: "00" for EP2OUT, "10" for EP6IN
		fx2Data_io     : inout std_logic_vector(7 downto 0); -- 8-bit data to/from FX2LP

		-- When EP2OUT selected:
		fx2Read_out    : out   std_logic;                    -- asserted (active-low) when reading from FX2LP
		fx2OE_out      : out   std_logic;                    -- asserted (active-low) to tell FX2LP to drive bus
		fx2GotData_in  : in    std_logic;                    -- asserted (active-high) when FX2LP has data for us

		-- When EP6IN selected:
		fx2Write_out   : out   std_logic;                    -- asserted (active-low) when writing to FX2LP
		fx2GotRoom_in  : in    std_logic;                    -- asserted (active-high) when FX2LP has room for more data from us
		fx2PktEnd_out  : out   std_logic;                    -- asserted (active-low) when a host read needs to be committed early

		-- Onboard peripherals -----------------------------------------------------------------------
		leds           : out std_logic_vector(7 downto 0);
		rst_n          : in  std_logic							  -- reset activo bajo
	);
end top_level;

architecture structural of top_level is

component fifo32to8
  port (
    rst : in std_logic;
    wr_clk : in std_logic;
    rd_clk : in std_logic;
    din : in std_logic_vector(31 downto 0);
    wr_en : in std_logic;
    rd_en : in std_logic;
    dout : out std_logic_vector(7 downto 0);
    full : out std_logic;
    empty : out std_logic;
    valid : out std_logic
  );
end component;

component fifo8to32
  port (
    rst : in std_logic;
    wr_clk : in std_logic;
    rd_clk : in std_logic;
    din : in std_logic_vector(7 downto 0);
    wr_en : in std_logic;
    rd_en : in std_logic;
    dout : out std_logic_vector(31 downto 0);
    full : out std_logic;
    empty : out std_logic;
    valid : out std_logic
  );
end component;

component tictoc is
    generic( toc_max : natural);
    port ( clk : in  std_logic;
           rst : in  std_logic;
           tocup : in  std_logic_vector (ceil2power(toc_max) - 1 downto 0);
           tocdown : in  std_logic_vector (ceil2power(toc_max) - 1 downto 0);
           tic : in  std_logic;
           toc : out  std_logic
			  );
end component;

component comm_fpga_fx2 is
	port(
		clk_in         : in    std_logic;                     -- 48MHz clock from FX2LP
		reset_in       : in    std_logic;                     -- synchronous active-high reset input
		reset_out      : out   std_logic;                     -- synchronous active-high reset output

		-- FX2LP interface ---------------------------------------------------------------------------
		fx2FifoSel_out : out   std_logic;                     -- select FIFO: '0' for EP2OUT, '1' for EP6IN
		fx2Data_io     : inout std_logic_vector(7 downto 0);  -- 8-bit data to/from FX2LP

		-- When EP2OUT selected:
		fx2Read_out    : out   std_logic;                     -- asserted (active-low) when reading from FX2LP
		fx2GotData_in  : in    std_logic;                     -- asserted (active-high) when FX2LP has data for us

		-- When EP6IN selected:
		fx2Write_out   : out   std_logic;                     -- asserted (active-low) when writing to FX2LP
		fx2GotRoom_in  : in    std_logic;                     -- asserted (active-high) when FX2LP has room for more data from us
		fx2PktEnd_out  : out   std_logic;                     -- asserted (active-low) when a host read needs to be committed early

		-- Channel read/write interface --------------------------------------------------------------
		chanAddr_out   : out   std_logic_vector(6 downto 0);  -- the selected channel (0-127)

		-- Host >> FPGA pipe:
		h2fData_out    : out   std_logic_vector(7 downto 0);  -- data lines used when the host writes to a channel
		h2fValid_out   : out   std_logic;                     -- '1' means "on the next clock rising edge, please accept the data on h2fData_out"
		h2fReady_in    : in    std_logic;                     -- channel logic can drive this low to say "I'm not ready for more data yet"

		-- Host << FPGA pipe:
		f2hData_in     : in    std_logic_vector(7 downto 0);  -- data lines used when the host reads from a channel
		f2hValid_in    : in    std_logic;                     -- channel logic can drive this low to say "I don't have data ready for you"
		f2hReady_out   : out   std_logic                      -- '1' means "on the next clock rising edge, put your next byte of data on f2hData_in"
	);
end component;

-- FPGALINK

	-- Channel read/write interface -----------------------------------------------------------------
	signal chanAddr  : std_logic_vector(6 downto 0);  -- the selected channel (0-127)

	-- Host >> FPGA pipe:
	signal h2fData   : std_logic_vector(7 downto 0);  -- data lines used when the host writes to a channel
	signal h2fValid  : std_logic;                     -- '1' means "on the next clock rising edge, please accept the data on h2fData"
	signal h2fReady  : std_logic;                     -- channel logic can drive this low to say "I'm not ready for more data yet"

	-- Host << FPGA pipe:
	signal f2hData   : std_logic_vector(7 downto 0);  -- data lines used when the host reads from a channel
	signal f2hValid  : std_logic;                     -- channel logic can drive this low to say "I don't have data ready for you"
	signal f2hReady  : std_logic;                     -- '1' means "on the next clock rising edge, put your next byte of data on f2hData"
	-- ----------------------------------------------------------------------------------------------

	-- Needed so that the comm_fpga_fx2 module can drive both fx2Read_out and fx2OE_out
	signal fx2Read   : std_logic;

	-- Reset signal so host can delay startup
	signal fx2Reset  : std_logic;

-- USER	
    
    signal rst: std_logic;
	constant CLOCK_FREQ : natural := 48e6; --48 Mhz
	
	signal rden_fifo8to32 : std_logic;
	signal dout_fifo8to32 : std_logic_vector(31 downto 0);
	signal full_h2f		 : std_logic;
	signal full_f2h       : std_logic;
	
	signal emptyfifo8to32 : std_logic;
	signal dv_fifo8to32	 : std_logic;
	
	signal din_fifo32to8  : std_logic_vector(31 downto 0);
	signal wren_fifo32to8 : std_logic;
	signal rden_fifo32to8 : std_logic;
	signal emptyfifo32to8 : std_logic;

	signal clk            : std_logic;
	signal reset_register : std_logic_vector(5 downto 0) := "111111";
	signal reset_sync     : std_logic;
	
begin
   clk <= fx2Clk_in;
	-- CommFPGA module
	fx2Read_out <= fx2Read;
	fx2OE_out <= fx2Read;
	fx2Addr_out(0) <=  -- So fx2Addr_out(1)='0' selects EP2OUT, fx2Addr_out(1)='1' selects EP6IN
		'0' when fx2Reset = '0'
		else 'Z';
		
	comm_fpga_fx2_inst : comm_fpga_fx2
		port map(
			clk_in         => clk,
			reset_in       => rst,
			reset_out      => fx2Reset,
			
			-- FX2LP interface
			fx2FifoSel_out => fx2Addr_out(1),
			fx2Data_io     => fx2Data_io,
			fx2Read_out    => fx2Read,
			fx2GotData_in  => fx2GotData_in,
			fx2Write_out   => fx2Write_out,
			fx2GotRoom_in  => fx2GotRoom_in,
			fx2PktEnd_out  => fx2PktEnd_out,

			-- DVR interface -> Connects to application module
			chanAddr_out   => chanAddr,
			h2fData_out    => h2fData,
			h2fValid_out   => h2fValid,
			h2fReady_in    => h2fReady,
			f2hData_in     => f2hData,
			f2hValid_in    => f2hValid,
			f2hReady_out   => f2hReady
		);

rst <= rst_n;  -- ACTIVO ALTO
h2fReady  <= '1'; -- FPGA siempre lista

fifo_h2f : fifo8to32
  PORT MAP (
    rst    => fx2Reset,
    wr_clk => clk,
    rd_clk => clk,
    din    => h2fData,
    wr_en  => h2fValid,
    rd_en  => rden_fifo8to32,
    dout   => dout_fifo8to32,
    full   => full_h2f,
    empty  => emptyfifo8to32,
    valid  => dv_fifo8to32
  );

rden_fifo8to32 <= not emptyfifo8to32;
	
din_fifo32to8  <= dout_fifo8to32;
wren_fifo32to8 <= dv_fifo8to32;		

fifo_f2h : fifo32to8
  PORT MAP (
    rst    => fx2Reset,
    wr_clk => clk,
    rd_clk => clk,
    din    => din_fifo32to8,
    wr_en  => wren_fifo32to8,
    rd_en  => rden_fifo32to8,
    dout   => f2hData,
    full   => full_f2h,
    empty  => emptyfifo32to8,
    valid  => f2hValid
  );
  
  rden_fifo32to8 <= f2hReady and (not emptyfifo32to8); 
   
 process(clk)
  begin

		if(clk = '1' and clk'event) then
			if (fx2Reset = '1') then
				reset_register(5) <= '1';
			else
				reset_register(5) <= '0';
			end if;
			
				reset_register(4) <= reset_register(5);
				reset_register(3) <= reset_register(4);
				reset_register(2) <= reset_register(3);
				reset_register(1) <= reset_register(2);
				reset_register(0) <= reset_register(1);
			
		end if;
  end process;
  
  reset_sync <= reset_register(0);
    
  --blinks implementados con modulo tictoc
		
	rx_led_tic: tictoc
    generic map
		( TOC_MAX  => CLOCK_FREQ)
    port map
		( clk   => clk,
        rst   => reset_sync,
        tocup => std_logic_vector(to_unsigned( CLOCK_FREQ /8, ceil2power(CLOCK_FREQ))),
        tocdown => std_logic_vector(to_unsigned( CLOCK_FREQ /8, ceil2power(CLOCK_FREQ))),
        tic   => dv_fifo8to32,
        toc   => leds(0)
		);

  tx_led_tic: tictoc
    generic map
		( TOC_MAX  => CLOCK_FREQ)
    port map
		( clk   => clk,
        rst   => reset_sync,
        tocup => std_logic_vector(to_unsigned( CLOCK_FREQ /8, ceil2power(CLOCK_FREQ))),
        tocdown => std_logic_vector(to_unsigned( CLOCK_FREQ /8, ceil2power(CLOCK_FREQ))),
        tic   => f2hValid,
        toc   => leds(1)
		);

	leds(7 downto 2) <= (others => '0');
	
end architecture;
