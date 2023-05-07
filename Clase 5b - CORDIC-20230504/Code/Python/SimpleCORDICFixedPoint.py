# -*- coding: utf-8 -*-
''' Implementación básica del algoritmo de CORDIC
'''
import numpy as np
import matplotlib.pyplot as plt
from FixedPoint import FXfamily, FXnum  # Para instalar: pip3 install spfpm


FXnumVect = np.vectorize(FXnum)


class SimpleCORDIC:
    '''Implementa una forma básica del algoritmo de CORDIC (con punto fijo)
    '''

    def __init__(self, x=0.5, y=0.5, itera=10):
        '''Inicialización de parámetros y "buffers".
        Por deafult el algoritmo se instancia con el vector inicial (0.5, 0.5)
        y 10 iteraciones.
        '''
        # Precisión de los datos:
        self.__precAngle = FXfamily(12, 4)
        self.__precValues = FXfamily(10, 2)
        # Número de iteraciones:
        self.__iter = itera
        # LUT de valores de arcotangente:
        self.__LUT = FXnumVect(np.arctan(
                        np.exp2(-1 * np.array(range(self.__iter)))),
                        self.__precAngle)
        # Ganancia del algoritmo:
        self.__A = FXnum(1, self.__precValues)
        # "Registros":
        self.__x_i = FXnumVect(np.zeros(self.__iter + 1), self.__precValues)
        self.__y_i = FXnumVect(np.zeros(self.__iter + 1), self.__precValues)
        self.__z_i = FXnumVect(np.zeros(self.__iter + 1), self.__precAngle)
        # Valores iniciales:
        self.__x_i[0] = FXnum(x, self.__precValues)
        self.__y_i[0] = FXnum(y, self.__precValues)
        # Figura:
        self.fig1 = plt.figure(figsize=(8, 8))
        self.__initFigure()

    def setInitVector(self, x, y):
        self.__x_i[0] = FXnum(x, self.__precValues)
        self.__y_i[0] = FXnum(y, self.__precValues)

    def mathRotation(self, angle):
        '''Rotación matemática estandar
        '''
        x = float(self.__x_i[0])
        y = float(self.__y_i[0])
        # Plot del vector original:
        plt.plot([0, x], [0, y],  color="blue", linewidth=4, marker='o')
        plt.annotate(u'Vector original', xy=(x, y),
                     xytext=(0.9, 0.5),
                     arrowprops=dict(facecolor='blue', shrink=0.05))
        # Cálculo:
        x_r = x * np.cos(angle) - y * np.sin(angle)
        y_r = y * np.cos(angle) + x * np.sin(angle)
        # Plot del vector resultante:
        plt.plot([0, x_r], [0, y_r],  color="red", linewidth=4, marker='o')
        plt.annotate(u'Rotación matemática', xy=(x_r, y_r), xytext=(0.8, 0.8),
                     arrowprops=dict(facecolor='red', shrink=0.05))
        return [x_r, y_r]

    def CORDICRotation(self, angle):
        '''Rotación iterativa por medio de CORDIC
        '''
        self.__A = FXnum(1, self.__precValues)
        self.__z_i[0] = FXnum(angle, self.__precAngle)

        for i in range(self.__iter):
            # ITERACIONES CORDIC
            if self.__z_i[i] < 0:
                self.__x_i[i+1] = self.__x_i[i] + (self.__y_i[i] >> i)
                self.__y_i[i+1] = self.__y_i[i] - (self.__x_i[i] >> i)
                self.__z_i[i+1] = self.__z_i[i] + self.__LUT[i]
            else:
                self.__x_i[i+1] = self.__x_i[i] - (self.__y_i[i] >> i)
                self.__y_i[i+1] = self.__y_i[i] + (self.__x_i[i] >> i)
                self.__z_i[i+1] = self.__z_i[i] - self.__LUT[i]

            self.__A = FXnum(self.__A * np.sqrt(1 + (2**(-2*i))),
                             self.__precValues)

            plt.plot([0, (self.__x_i[i+1])/self.__A],
                     [0, (self.__y_i[i+1])/self.__A],
                     color="green", linewidth=5*i/self.__iter, marker='o')
        # Resultado
        x_r = self.__x_i[self.__iter]/self.__A
        y_r = self.__y_i[self.__iter]/self.__A

        plt.annotate(u'Rotación CORDIC', xy=(x_r, y_r), xytext=(0.7, 0.9),
                     arrowprops=dict(facecolor='green', shrink=0.05))

        return [float(x_r.toDecimalString()), float(y_r.toDecimalString())]

    def showGraph(self):
        '''Muestra la figura con la rotación
        '''
        self.fig1.show()
        input('Presione Enter para cerrar la figura...')

    def __initFigure(self):
        plt.title(u'Rotación vía CORDIC')
        plt.xlim(-0.1, 1.1)
        plt.ylim(-0.1, 1.1)
        plt.xticks([0, 0.25, 0.5, 0.75, 1])
        plt.yticks([0, 0.25, 0.5, 0.75, 1])


if __name__ == '__main__':
    plt.close('all')
    calculadora = SimpleCORDIC(0.9, 0.1, 5)
    print('Rotación matemática: {0}'.format(calculadora.mathRotation(np.pi/6)))
    print('Rotación CORDIC: {0}'.format(calculadora.CORDICRotation(np.pi/6)))
    calculadora.showGraph()
