// HelloWorld.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <vector>
#include <string>
#include <string_view>
#include <fstream>
bool okPaper(char ch1, char ch2, char ch3, char ch4, char ch5, char ch6, char ch7, char ch8);

std::vector<char> returnVector(std::string_view sv) {
	std::vector<char> row(sv.length()+2, '.');
	for (size_t i = 0; i < sv.length();i++) {
		row[i+1] = sv[i];
	}
	return row;
}
int PossiblePapers(std::vector<std::vector<char>>& matrix) {
	int sum1{ 0 };
	for (size_t i = 1; i < matrix.size()-1; i++) {
		for (size_t j = 1; j < matrix[i].size()-1; j++) {
			//std::cout << i << j;
			if (matrix[i][j] == '@') {
				if (okPaper(matrix[i - 1][j - 1], matrix[i - 1][j], matrix[i - 1][j + 1], matrix[i][j - 1],
					matrix[i][j + 1], matrix[i + 1][j - 1], matrix[i + 1][j], matrix[i + 1][j + 1])) {
					sum1++;
					matrix[i][j] = '.';
				}

			}
			//std::cout << " " << sum1<<'\n';
		}
	}
	return sum1;
}
bool okPaper(char ch1, char ch2, char ch3, char ch4, char ch5, char ch6, char ch7, char ch8) {
	std::string str{""};
	str += ch1;
	str += ch2;
	str += ch3;
	str += ch4;
	str += ch5;
	str += ch6;
	str += ch7;
	str += ch8;
	//std::cout << str << '\n';
	int counter{ 0 };
	for (char ch : str) {
		if (ch == '@') {
			counter++;
		}
	}
	if (counter >= 4) {
		return false;
	}
	else {
		return true;
	}
}

int main() {
	std::vector<std::vector<char>> matrix(2, std::vector<char>(22, '.'));
	
	std::ifstream inf{ "Text.txt" };
	size_t counter{ 0 };

	// If we couldn't open the output file stream for reading
	if (!inf)
	{
		// Print an error and exit
		std::cerr << "Uh oh, Sample.txt could not be opened for reading!\n";
		return 1;
	}
	std::string row{};
	while (std::getline(inf, row)) {
		//std::cout << row<<'\n';
		counter++;
		if (counter==1) {
			matrix[0].resize(row.length()+2, '.');
			matrix[1] = returnVector(row);
			counter++;
		}
		else {
			matrix.resize(counter, returnVector(row));
		}
		matrix.resize(counter, returnVector(row));
	}
	counter++;
	matrix.resize(counter, std::vector<char>(row.length() + 2, '.'));
	std::vector<std::vector<char>> prevmatrix(2, std::vector<char>(22, '.'));
	int sum1{ 0 };
	while (matrix != prevmatrix) {
		prevmatrix = matrix;
		sum1 += PossiblePapers(matrix);
	}
	//int sum1{ PossiblePapers(matrix) };

	/*for (std::vector<char > vec : matrix) {
		for (char ch : vec) { // 'num' is a copy of each element
			std::cout << ch << " ";
		}
		std::cout << '\n';
	}*/

	std::cout << sum1;
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
