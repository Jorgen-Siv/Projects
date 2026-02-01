// HelloWorld.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <string_view>
#include <string>
#include <fstream>

int signedRotation(std::string rot) {
	if (rot[0] == 'R') {
		return std::stoi(rot.substr(1));
	}
	else {
		return -std::stoi(rot.substr(1));
	}

}
int RotationEnd2(int start, int rotation, int& counter) {
	int end{ start + rotation };
	counter += abs(end) / 100;
	int rest{ rotation % 100 };
	if (rotation > 0) {
		if (start + rest >= 100) {
			counter++;
			return (start + rest) % 100;
		}
		return start + rest;
	}
	else {
		if (start > 0 && start + rest <= 0) {
			counter++;
			if (start + rest == 0) {
				return 0;
			}
			else {
				return 100 + start + rest;
			}
		}
		else if (start == 0 && start + rest <= 0) {
			return 100 + start + rest;
		}
		else {
			return start + rest;
		}
	}
}
int Rotationend3(int start, int rotation, int& counter) {
	int dial{ start };
	if (rotation < 0) {
		for (int i = 0; i < abs(rotation); i++) {
			dial = (dial - 1) % 100;
			if (dial == 0) {
				counter++;
			}
			if (dial == -1) {
				dial = 99;
			}
			
		}
	}
	else {
		for (int i = 0; i < abs(rotation); i++) {
			dial = (dial + 1);
			if (dial == 100) {
				counter++;
				dial = 0;
			}
		}
	}
	return dial;
}
	



int RotationEnd(int start, int rotation,int& counter) {
	int x{100};
	//std::cout << rotation / x<<"differance\n";
	counter += abs(rotation / x);
	//std::cout << rotation/x<<'\n';
	if (start != 0 && start + rotation%x <= 0) {
		counter++;
		if ((start + rotation % x) % x == 0) {
			return 0;
		}
		return 100+(start + rotation % x)%x;
	}
	else if(start != 0 && start+rotation%x>=100){
		counter++;
		return (start + rotation % x)%x;
	}
	else {
		if ((start + rotation % x) % x < 0) {
			return 100 + (start + rotation % x) % x;
		}
		return (start + rotation % x) % x;
	}
	
}

int main() {
	int counter = 0; //0 counter
	int start = 50;// start position of dial
	std::ifstream inf{ "Text.txt" };

	// If we couldn't open the output file stream for reading
	if (!inf)
	{
		// Print an error and exit
		std::cerr << "Uh oh, Sample.txt could not be opened for reading!\n";
		return 1;
	}
	std::string rotate{};
	while (std::getline(inf, rotate)) {
		int r{ signedRotation(rotate) };
		int rend{ Rotationend3(start, r, counter) };
	
		start = rend;
		std::cout << counter<<'\n';
		//std::cout << start << '\n';
		std::cout << rend<<'\n';
	}
	std::cout << counter;
	
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
