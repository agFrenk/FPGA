# -*- coding: utf-8 -*-
''' Implementación básica del algoritmo de CORDIC
'''
import numpy as np
import matplotlib.pyplot as plt


class SimpleCORDIC:
    '''Implementa una forma básica del algoritmo de CORDIC
    '''

    def __init__(self, x=0, y=1, itera=10):
        '''Inicialización de parámetros y "buffers". Por deafult el algoritmo
        se instancia con el vector inicial (0,1) y 10 iteraciones.
        '''
        self.__iter = itera  # Número de iteraciones
        self.__x_0 = x  # Vector inicial
        self.__y_0 = y
        # LUT de valores de arcotangente
        self.__LUT = np.arctan(np.exp2(-1 * np.array(range(self.__iter))))
        self.__LUTdeg = np.deg2rad(self.__LUT)
        self.__A = 1  # Ganancia del algoritmo
        self.__x_i = np.empty(self.__iter + 1)
        self.__y_i = np.empty(self.__iter + 1)
        self.__z_i = np.empty(self.__iter + 1)
        self.__d_i = np.empty(self.__iter + 1)
        # "Registros"
        self.__x_i[0] = self.__x_0
        self.__y_i[0] = self.__y_0
        # Figura
        self.fig1 = plt.figure(figsize=(8, 7))
        self.__initFigure()

    def setInitVector(self, x, y):
        self.__x_0 = x
        self.__y_0 = y

    def mathRotation(self, angle):
        '''Rotación matemática estandar
        '''
        # Plot del vector resultante
        plt.plot([0, self.__x_0], [0, self.__y_0],  color="blue",
                 linewidth=4, marker='o')
        plt.annotate(u'Vector original', xy=(self.__x_0, self.__y_0),
                     xytext=(-0.3, 1), arrowprops=dict(facecolor='blue',
                                                       shrink=0.05))
        # Cálculo
        x_r = self.__x_0 * np.cos(angle) - self.__y_0 * np.sin(angle)
        y_r = self.__y_0 * np.cos(angle) + self.__x_0 * np.sin(angle)
        # Plot del vector resultante
        plt.plot([0, x_r], [0, y_r],  color="red", linewidth=4, marker='o')
        plt.annotate(u'Rotación matemática', xy=(x_r, y_r), xytext=(-1, 1),
                     arrowprops=dict(facecolor='red', shrink=0.05))
        return [x_r, y_r]

    def CORDICRotation(self, angle):
        '''Rotación iterativa por medio de CORDIC
        '''
        self.__A = 1
        self.__z_i[0] = angle

        for i in range(self.__iter):
            # ITERACIONES CORDIC
            if self.__z_i[i] < 0:
                self.__d_i[i] = -1.0
            else:
                self.__d_i[i] = 1.0

            self.__x_i[i+1] = self.__x_i[i]\
                - self.__y_i[i] * self.__d_i[i] * (2 ** (-i))
            self.__y_i[i+1] = self.__y_i[i]\
                + self.__x_i[i] * self.__d_i[i] * (2 ** (-i))
            self.__z_i[i+1] = self.__z_i[i] - self.__d_i[i] * self.__LUT[i]

            self.__A = self.__A * np.sqrt(1 + (2**(-2*i)))

            plt.plot([0, self.__x_i[i+1]/self.__A],
                     [0, self.__y_i[i+1]/self.__A],
                     color="green", linewidth=5*i/self.__iter, marker='o')
        # Resultado
        x_r = self.__x_i[self.__iter]/self.__A
        y_r = self.__y_i[self.__iter]/self.__A

        plt.annotate(u'Rotación CORDIC', xy=(x_r, y_r), xytext=(-1, 0.9),
                     arrowprops=dict(facecolor='green', shrink=0.05))

        return [x_r, y_r]

    def showGraph(self):
        '''Muestra la figura con la rotación
        '''
        self.fig1.show()
        input('Presione Enter para cerrar la figura...')

    def __initFigure(self):
        plt.title(u'Rotación vía CORDIC')
        plt.xlim(-1.1, 0.1)
        plt.ylim(-0.1, 1.1)
        plt.xticks([-1, -0.5, 0])
        plt.yticks([0, 0.5, 1])

if __name__ == '__main__':
    plt.close('all')
    # plt.figure(figsize=(8, 7))
    calculadora = SimpleCORDIC(-0.1, 0.9, 10)
    print(calculadora.mathRotation(np.pi/6))
    print(calculadora.CORDICRotation(np.pi/6))
    calculadora.showGraph()
