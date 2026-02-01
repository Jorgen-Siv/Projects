// HelloWorld.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <string_view>


bool checkS(char ch) {
	return ch == 'S';
}

bool checkLine(char ch) {
	return ch == '|';
}
bool checkhat(char ch) {
	return ch == '^';
}
std::vector<char> createVector(std::string_view sv) {
	std::vector<char> vec(sv.length(), '0');
	for (size_t i = 0;i<sv.length();i++) {
		vec[i] = sv[i];
		//std::cout << sv[i];
	}
	return vec;
}



int main() {
	std::ifstream inf{ "Text.txt" };
	std::vector<std::vector<char>> matrix(2, std::vector<char>(2,'0'));

	// If we couldn't open the output file stream for reading
	if (!inf)
	{
		// Print an error and exit
		std::cerr << "Uh oh, Sample.txt could not be opened for reading!\n";
		return 1;
	}
	size_t rowcounter{ 0 };
	int splitcounter{ 0 };

	std::string row{};

	while (std::getline(inf, row)) {
		if (rowcounter == 0 || rowcounter == 1) {
			matrix[rowcounter] = createVector(row);
		}
		else {
			matrix.resize(rowcounter + 1, createVector(row));
		}
		rowcounter++;
	}
	for (size_t i = 0; i < matrix.size(); i++) {
		for (size_t j = 0; j < matrix[i].size(); j++) {
			if (checkS(matrix[i][j])) {
				matrix[i + 1][j] = '|';
			}
			else if (checkhat(matrix[i][j])) {
				//std::cout << "JA";
				if (checkLine(matrix[i - 1][j])) {
					matrix[i][j - 1] = '|';
					matrix[i][j + 1] = '|';
					splitcounter++;
				}
			}
			else if (i >= 1) {
				if (checkLine(matrix[i - 1][j])) {
					matrix[i][j] = '|';
				}
			}
		}
	}
	/*for (size_t i = 0; i < matrix.size(); i++) {
		for (size_t j = 0; j < matrix[i].size(); j++) {
			std::cout << matrix[i][j];
		}
		std::cout << '\n';
	}*/
		
	std::cout << "Hello world!";
	std::cout << splitcounter;
	return 0;
}
// Run program: Ctrl + F5 or Debug > Start Without Debugging menu
// Debug program: F5 or Debug > Start Debugging menu

// Tips for Getting Started: 
//   1. Use the Solution Explorer window to add/manage files
//   2. Use the Team Explorer window to connect to source control
//   3. Use the Output window to see build output and other messages
//   4. Use the Error List window to view errors
//   5. Go to Project > Add New Item to create new code files, or Project > Add Existing Item to add existing code files to the project
//   6. In the future, to open this project again, go to File > Open > Project and select the .sln file
