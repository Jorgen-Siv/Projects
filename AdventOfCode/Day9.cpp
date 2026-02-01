// HelloWorld.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <algorithm>
#include <sstream>

class redSpace {
public:
	long long x;
	long long y;
};

long long areaCalc(redSpace r1, redSpace r2) {
	//std::cout << (r2.x - r1.x) * (r2.y - r1.y);
	return (std::abs(r2.x - r1.x)+1) * (std::abs(r2.y - r1.y)+1);
}
long long LargestArea(std::vector<redSpace> rs) {
	long long largestArea{ 0 };
	for (redSpace r1 : rs) {
		for (redSpace r2 : rs){
			if (areaCalc(r1, r2) > largestArea) {
				//std::cout << largestArea<<" ";
				largestArea = areaCalc(r1, r2);
			}
		}
	}
	return largestArea;
}
int main(){
	std::vector<redSpace> Redspaces{};
	std::ifstream inf{ "Text.txt" };
	if (!inf){
		// Print an error and exit
		std::cerr << "Uh oh, Sample.txt could not be opened for reading!\n";
		return 1;
	}
	std::string row{};
	while (std::getline(inf, row)) {
		std::istringstream iss(row);
		std::string xy{};
		redSpace tempSpace{};
		int counter{ 0 };
		while (std::getline(iss, xy, ',')) {
			if (counter == 0) {
				tempSpace.x = std::stoi(xy);
			}
			else {
				tempSpace.y = std::stoi(xy);
			}
			counter++;
			//std::cout << tempSpace.x<<"  \n";
		}
		Redspaces.resize(Redspaces.size() + 1, tempSpace);
	}
	std::cout << LargestArea(Redspaces);

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
