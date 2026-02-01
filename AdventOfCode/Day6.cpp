#include <iostream>
#include <vector>
#include <string>
#include <fstream>
#include <sstream>
#include <cmath>

std::vector<size_t> findStartpos(std::string_view row) {
	std::vector<size_t> startpos(2, 0);
	size_t counter{ 0 };
	for (size_t i = 0; i < row.length(); i++) {
		if (row[i] == '*' || row[i] == '+') {
			if(counter < 2){
				startpos[counter] = i;
			}
			else {
				startpos.resize(counter + 1, i);
			}
			counter++;
		}
	}
	return startpos;
}



int main() {
	std::ifstream inf{ "Text.txt" };
	std::vector<std::vector<long long>> numberproblemsPart1(2, std::vector<long long>(2, 0));
	std::vector<char>symbolPart1(2, '0');
	std::vector<size_t> startpos;
	std::vector<std::string> rowstrings(2, "0");


	std::vector<char> operators(2, '-');
	//std::vector<long long> validIDs(2, 0);
	//long long sum1{ 0 };
	size_t rowcounter{ 0 };

	//No file opened
	if (!inf)
	{
		// Print an error and exit
		std::cerr << "Uh oh, Sample.txt could not be opened for reading!\n";
		return 1;
	}
	std::string row{};

	while (std::getline(inf, row)) {
		if (row == "") {
			break;
		}
		if (row[0] == '*' || row[0] == '+') {
			startpos = findStartpos(row);
		}
		if (rowcounter == 0 || rowcounter == 1) {
			rowstrings[rowcounter] = row;
		}
		else {
			rowstrings.resize(rowcounter + 1, row);
		}
		std::istringstream iss(row);
		std::istringstream iss2(row);
		std::string tempstr{};
		size_t problemcounter{ 0 };
		std::string number{};
		while (iss >> number) {
			std::cout << number << '\n';
			if (number[0] == '+' || number[0] == '*') {
				//std::cout << number[0];
				if (problemcounter < 2) {
					symbolPart1[problemcounter] = number[0];
				}
				else {
					symbolPart1.resize(problemcounter + 1, number[0]);
				}
			}
			else{
				if (rowcounter < 2) {
					if (problemcounter < 2) {
						numberproblemsPart1[rowcounter][problemcounter] = std::stoll(number);
					}
					else {
						numberproblemsPart1[rowcounter].resize(problemcounter + 1, std::stoll(number));
					}
				}
				else {
					numberproblemsPart1.resize(rowcounter + 1, std::vector<long long>(2, 0));
					if (problemcounter < 2) {
						numberproblemsPart1[rowcounter][problemcounter] = std::stoll(number);
					}
					else {
						numberproblemsPart1[rowcounter].resize(problemcounter + 1, std::stoll(number));
					}
				}
			}
			problemcounter++;
		}
		rowcounter++;
		}
	long long totalsumP1{ 0 };
	for (size_t i = 0; i < symbolPart1.size(); i++) {
		long long tempSum{ 0 };
		for (size_t j = 0; j < rowcounter-1; j++) {
			if (symbolPart1[i] == '*') {
				if (tempSum == 0) {
					tempSum = 1;
				}
				tempSum *= numberproblemsPart1[j][i];
			}
			else if (symbolPart1[i] == '+') {
				tempSum += numberproblemsPart1[j][i];
			}
		}
		totalsumP1 += tempSum;
	}
	for (size_t i = 0; i < startpos.size(); i++) {
		std::cout << startpos[i] << '\n';
	}
	std::cout << "Svar: " << totalsumP1;
	return 0;
}