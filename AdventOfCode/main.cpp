// HelloWorld.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <string>
#include <string_view>
#include <fstream>
#include <sstream>

/*long long getSumPerRange(int rangestart, int rangeend) {
	long long sum1{ 0 };
	for (int i = rangestart; i <= rangeend; i++) {
		std::string str{ std::to_string(i) };
		int len{ static_cast<int> (std::ssize(str))};
		if (len % 2 == 0) {
			if (std::stoll(str.substr(0, len / 2)) == std::stoll(str.substr(len / 2))) {
				sum1 += i;
			}
		}
	}
	return sum1;
}*/


long long getSumPerRange(long long rangestart, long long rangeend) {
	long long sum1 = 0;
	for (long long i = rangestart; i <= rangeend; i++) {
		std::string str = std::to_string(i);
		size_t len = str.size();
		if (len % 2 == 0) {
			long long a = std::stoll(str.substr(0, len / 2));
			long long b = std::stoll(str.substr(len / 2));
			if (a == b) {
				sum1 += i;
			}
		}
	}
	return sum1;
}
bool allSame(std::string_view sv) {
	char first{ sv[0] };
	for (int i = 1; i < sv.length(); i++) {
		if (sv[i] != first) {
			return false;
		}
	}
	return true;
}
long long getSumPerRange2(long long rangestart, long long rangeend) {
	long long sum1 = 0;
	for (long long i = rangestart; i <= rangeend; i++) {
		bool invalid{ false };
		std::string str = std::to_string(i);
		size_t len = str.size();
		if (len % 2 == 0) {
			long long a = std::stoll(str.substr(0, len / 2));
			long long b = std::stoll(str.substr(len / 2));
			if (a == b) {
				std::cout << "2: " << i << '\n';
				invalid=true;
			}
		}
		if (len % 3 == 0) {
			long long a = std::stoll(str.substr(0, len / 3));
			long long b = std::stoll(str.substr(len / 3,len/3));
			long long c = std::stoll(str.substr(2 * len / 3));
			if ((a==b)&&(a==c)) {
				std::cout << "3: " << i <<'\n';

				invalid = true;
			}
		}
		if (len % 4 == 0) {
			long long a = std::stoll(str.substr(0, len / 4));
			long long b = std::stoll(str.substr(len / 4, len / 4));
			long long c = std::stoll(str.substr(2 * len / 4, len / 4));
			long long d = std::stoll(str.substr(3 * len / 4));
			if (a == b &&a== c && a==d) {
				std::cout << "4: " << i << '\n';
				invalid = true;
			}
		}
		if (len % 5 == 0) {
			long long a = std::stoll(str.substr(0, len / 5));
			long long b = std::stoll(str.substr(1 * len / 5, len / 5));
			long long c = std::stoll(str.substr(2 * len / 5,  len / 5));
			long long d = std::stoll(str.substr(3 * len / 5,  len / 5));
			long long e = std::stoll(str.substr(4 * len / 5));
			if (a == b &&a == c &&a == d && a==e) {
				std::cout << "5: " << i << '\n';
				invalid = true;
			}
		}
						
		if (allSame(str)&&len>1) {
			std::cout << "1: " << i << '\n';
			invalid = true;
		}
		if (invalid) {
			sum1 += i;
		}

	}
	return sum1;
}

int main() {
	long long sum1{};
	std::ifstream inf{ "Text.txt" };
	if (!inf)
	{
		// Print an error and exit
		std::cerr << "Uh oh, Sample.txt could not be opened for reading!\n";
		return 1;
	}
	std::string range{};
	while (std::getline(inf, range,',')) {
		std::cout << range<<'\n';
		std::istringstream iss(range);
		std::string start{};
		std::string end{};
		std::getline(iss, start, '-');
		std::getline(iss, end);
		//sum1 += getSumPerRange(std::stoi(start), std::stoi(end));
		try {
			sum1 += getSumPerRange2(std::stoll(start), std::stoll(end));
		}
		catch (const std::exception& e) {
			std::cerr << "Error parsing start=" << start
				<< ", end=" << end << ": " << e.what() << "\n";
			return 1;
		}
		
		//std::cout << "oki: " << sum1<<'\n';
	}
	//int sum1{ getSumPerRange(38593856,38593862) };
	std::cout <<"here"<< sum1;
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
