#!/usr/bin/env python3
"""
solver.py

    Implements the matrix decoding scheme with the inverse matrix cipher
"""
import ast
import os


class Element:
    def __init__(self, row, column, value):
        self.row = row
        self.column = column
        self.value = value


class Matrix:
    def __init__(self, rows, columns):
        self.matrix = []
        self.rows = rows
        self.columns = columns
        self.__create_blank_matrix(rows, columns)

    def set_matrix_values(self, values):
        self.matrix.clear()
        for i in range(self.rows):
            for j in range(self.columns):
                if self.columns*i + j < len(values):
                    self.matrix.append(Element(i, j, values[self.columns*i + j]))

    def __create_blank_matrix(self, rows, columns):
        for i in range(rows):
            for j in range(columns):
                self.matrix.append(Element(i, j, len(self.matrix)))

    def __mul__(self, other):
        return self.multiply_with_matrix(other)

    def __str__(self):
        matrix_string = ""
        for i in range(self.rows):
            for j in range(self.columns):
                matrix_string += str(self.matrix[self.columns*i + j].value)
                matrix_string += " "
            if i < self.rows - 1:
                matrix_string += os.linesep
        return matrix_string

    def multiply_with_matrix(self, other_matrix):
        dimensions = self.get_matrix_product_dimensions(other_matrix)

        if dimensions is not None:
            new_matrix = Matrix(dimensions[0], dimensions[1])
            new_matrix.matrix.clear()

            for i in range(new_matrix.rows):
                for j in range(new_matrix.columns):
                    new_matrix.matrix.append(self.new_element_from_multiplication(other_matrix, i, j))
            return new_matrix
        else:
            return None

    def new_element_from_multiplication(self, other_matrix, row, column):
        new_element = Element(row, column, 0)
        sum = 0

        for i in range(self.columns):
            sum += self.matrix[self.columns*row + i].value * other_matrix.matrix[other_matrix.columns*i + column].value
        new_element.value = sum
        return new_element

    def get_matrix_product_dimensions(self, other_matrix):
        if self.can_be_multiplied_with_matrix(other_matrix):
            return self.rows, other_matrix.columns
        else:
            return None

    def can_be_multiplied_with_matrix(self, other_matrix):
        if self.columns == other_matrix.rows:
            return True
        else:
            return False

class Decoder:
    def __init__(self, decoder_matrix):
        self.message_list = []
        self.characters = [" ", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q",
                           "r", "s", "t", "u", "v", "w", "x", "y", "z"]
        self.decoder_matrix = decoder_matrix
        self.chunk_size = decoder_matrix.rows

    def set_message(self, message):
        self.message_list = message

    def __convert_list_to_message(self, message_list):
        message = ""
        for element in message_list:
            if element != -1:
                message += self.characters[element]
        return message

    def decode_message(self):
        number_of_chunks = int(len(self.message_list) / self.chunk_size)
        decoded_message_list = []

        for i in range(number_of_chunks):
            message_chunk = self.message_list[i * self.chunk_size: (i * self.chunk_size) + self.chunk_size]
            matrix = Matrix(3, 1)
            matrix.set_matrix_values(message_chunk)

            decoded_matrix = self.decoder_matrix.__mul__(matrix)

            for element in decoded_matrix.matrix:
                decoded_message_list.append(int(element.value))
        if len(self.message_list) % 3 > 0:
            message_chunk = self.message_list[
                            number_of_chunks * self.chunk_size: (number_of_chunks * self.chunk_size) + self.chunk_size]
            matrix = Matrix(3, 1)
            matrix.set_matrix_values(message_chunk)

            decoded_matrix = self.decoder_matrix.__mul__(matrix)

            for element in decoded_matrix.matrix:
                decoded_message_list.append(int(element.value))

        decoded_message = self.__convert_list_to_message(decoded_message_list)
        return decoded_message


decoder_matrix = Matrix(3,3)
decoder_matrix.set_matrix_values([-18/271, 37/271, -8/271,
                                  61/271, -20/271, -3/271,
                                  -41/271, 9/271, 42/271])

cts = []
with open("messages.txt", "r") as fd:
    cts = fd.readlines()

for ct in cts:

    ct = ast.literal_eval(ct.strip())
    decoder = Decoder(decoder_matrix)
    decoder.set_message(ct)
    decoded_message = decoder.decode_message()
    print(decoded_message)
