LIB:=utils
STD:=02

SRCS:= tipos.vhd funciones.vhd

OBJS:= $(LIB)-obj??.cf $(SRCS:.vhd=.o) 

$(OBJS): $(SRCS)
	ghdl -a --std=$(STD) --work=utils tipos.vhd funciones.vhd

clean:
	@rm -rf $(OBJS)
