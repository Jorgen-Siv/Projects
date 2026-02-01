

#include <iostream>
#include <string>
#include <string_view>
#include <fstream>

std::string FindStart(std::string_view numbers, std::string_view bank, int numbersleft) {
	std::string StartAnd{};
	for (size_t i = 0; i < numbers.length(); i++) {
		//std::cout << numbers[i]<<"h\n";
		for (size_t j = 0; j+numbersleft < bank.length(); j++) {
			if (bank[j] == numbers[i]) {
				StartAnd = bank.substr(j + 1);
				StartAnd.insert(0, 1, bank[j]);
				return StartAnd;
			}
		}
	}
	return StartAnd;
}
char FindSecondNum(std::string_view remain) {
	char largest{remain[0]};
	for (size_t i = 1; i < remain.length(); i++) {
		//std::cout << remain[i] << '\n';
		if (remain[i] > largest) {
			largest = remain[i];
		}
	}
	return static_cast<char>(largest);

}

int main() {
	long long sum1{ 0 };
	std::string nume{ "9876543210" };
	std::string_view numbers{ nume };
	std::ifstream inf{ "Text.txt" };

	// If we couldn't open the output file stream for reading
	if (!inf)
	{
		// Print an error and exit
		std::cerr << "Uh oh, Sample.txt could not be opened for reading!\n";
		return 1;
	}
	std::string bank{};
	while (std::getline(inf, bank)) {
		std::string largestjolts{};
		std::string tempS{bank};
		for (int i = 11; i >=0; i--) {
			std::string temp2=FindStart(numbers, tempS, i);
			largestjolts += temp2[0];
			//std::cout << largestjolts<<'\n';
			temp2.erase(0,1);
			tempS = temp2;

		}
		//std::string StartAndRest{ FindStart(numbers, bank) };
		//largestjolts += StartAndRest[0];
		//char second{ FindSecondNum(StartAndRest.substr(1)) };
		//largestjolts += second;
		std::cout << largestjolts<<'\n';
		sum1 += std::stoll(largestjolts);

	}
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

