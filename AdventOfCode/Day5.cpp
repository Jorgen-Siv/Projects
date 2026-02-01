// HelloWorld.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <algorithm>
#include <sstream>

bool overlap(long long start1, long long end1, long long start2, long long end2) {
	return (start1 <= end2 && start2 <= end1);
}
long long validID(long long start, long long end) {
	return end - start + 1;
}

bool inRange(long long start, long long end, long long ID) {
	if (ID >= start && ID <= end) {
		return true;
	}
	else {
		return false;
	}
}

int main() {

	std::ifstream inf{ "Text.txt" };
	std::vector<long long> start(2, 0);
	std::vector<long long> end(2, 0);
	std::vector<long long> nonoverlapstart(2, 0);
	std::vector<long long> nonoverlapend(2, 0);
	std::vector<long long> Resetnonoverlapstart(2, 0);
	std::vector<long long> Resetnonoverlapend(2, 0);
	//std::vector<long long> validIDs(2, 0);
	int sum1{ 0 };
	size_t sum2{ 0 };
	size_t counter{ 0 };
	size_t counter2{ 0 };

	// If we couldn't open the output file stream for reading
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
		std::istringstream iss(row);
		std::string startstr{};
		std::string endstr{};
		std::getline(iss, startstr, '-');
		std::getline(iss, endstr);
		long long starttemp{ std::stoll(startstr) };
		long long endtemp{ std::stoll(endstr) };
		if (counter == 0 || counter == 1) {
			start[counter] = starttemp;
			end[counter] = endtemp;
		}
		else {
			start.resize(counter + 1, starttemp);
			end.resize(counter + 1, endtemp);
		}
		counter++;


	}
	while (std::getline(inf, row)) {
		long long id{ std::stoll(row) };
		for (size_t i = 0; i < start.size(); i++) {
			if (inRange(start[i], end[i], id)) {
				sum1++;
				break;
			}
		}
	}
	while (true) {
		std::cout << "yes"<<'\n';
		for (size_t i = 0; i < start.size(); i++) {
			bool overlapped{ false };
			for (size_t j = 0; j < nonoverlapstart.size(); j++) {
				if (overlap(start[i], end[i], nonoverlapstart[j], nonoverlapend[j])) {
					long long tempstart{ 0 };
					long long tempend{ 0 };
					if (start[i] <= nonoverlapstart[j]) {
						tempstart = start[i];
					}
					else {
						tempstart = nonoverlapstart[j];
					}
					if (end[i] >= nonoverlapend[j]) {
						tempend = end[i];
					}
					else {
						tempend = nonoverlapend[j];
					}
					nonoverlapstart[j] = tempstart;
					nonoverlapend[j] = tempend;
					counter2++;
					overlapped = true;
					break;
				}
			}
			if (!overlapped) {
				if (counter2 == 0 || counter2 == 1) {
					nonoverlapstart[counter2] = start[i];
					nonoverlapend[counter2] = end[i];
				}
				else {
					nonoverlapstart.resize(counter2 + 1, start[i]);
					nonoverlapend.resize(counter2 + 1, end[i]);
				}
				counter2++;
			}


		}
		if (nonoverlapstart == start && nonoverlapend == end) {
			break;
		}
		start = nonoverlapstart;
		end = nonoverlapend;
		nonoverlapstart = Resetnonoverlapstart;
		nonoverlapend = Resetnonoverlapend;
		counter2 = 0;


	}
	for (size_t i = 0; i < nonoverlapstart.size(); i++) {
		std::cout << nonoverlapstart[i] << " " << nonoverlapend[i] << " " << validID(nonoverlapstart[i], nonoverlapend[i]) << '\n';
		sum2 += validID(nonoverlapstart[i], nonoverlapend[i]);
	}
	std::cout << sum1 << '\n';
	std::cout << sum2;
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

