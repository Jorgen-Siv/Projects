#include <iostream>
#include <vector>
#include <string>
#include <fstream>
#include <sstream>
#include <cmath>
#include <algorithm>
#include <set>


class Box {
	public:
		int x;
		int y;
		int z;
};	

double calcDistance(Box box1, Box box2) {
	double dx = box1.x - box2.x;
	double dy = box1.y - box2.y;
	double dz = box1.z - box2.z;
	return std::sqrt(dx * dx + dy * dy + dz * dz);
}
std::pair<size_t,size_t> shortestDistance(std::vector<std::vector<double>> distances) {
	double smallest{ 1000000 };
	size_t smallest_i{0};
	size_t smallest_j{ 0 };
	for (size_t i = 0; i < distances.size(); i++) {
		for (size_t j = 0; j < distances[i].size(); j++) {
			if (distances[i][j] < smallest) {
				smallest = distances[i][j];
				smallest_i = i;
				smallest_j = j;
			}
		}
	}
	return { smallest_i, smallest_j };
}
bool commonElement(std::vector<size_t> c1, std::vector<size_t> c2) {
	for (size_t i:c1) {
		if (std::count(c2.begin(), c2.end(), i)) {
			return true;
		}
	}
	return false;
}
std::vector<size_t> combine(std::vector<size_t> c1, std::vector<size_t> c2) {
	std::set<size_t> s;
	s.insert(c1.begin(), c1.end());
	s.insert(c2.begin(), c2.end());

	return std::vector<size_t>(s.begin(), s.end());
}
std::vector<size_t> xlargest(std::vector<size_t> sizes, int x) {
	if (x >= sizes.size()) {
		return sizes;
	}
	std::nth_element(sizes.begin(), sizes.end() - x, sizes.end());

	return std::vector<size_t>(sizes.end() - x, sizes.end());
}
size_t findXlargestandMultiply(std::vector<std::vector<size_t>> circuits, int X) {
	std::vector<size_t> sizes{};
	for (size_t i = 0; i < circuits.size(); i++) {
		sizes.resize(sizes.size() + 1, circuits[i].size());
	}
	std::vector<size_t> largest{ xlargest(sizes, X) };
	size_t temp{ 1 };
	for (size_t i = 0; i < largest.size(); i++) {
		temp *= largest[i];
	}
	return temp;
}


int main() {
	std::ifstream inf{ "Text.txt" };
	std::vector<Box> Boxes;
	
	//No file opened
	if (!inf)
	{
		// Print an error and exit
		std::cerr << "Uh oh, Sample.txt could not be opened for reading!\n";
		return 1;
	}
	std::string row{};
	size_t Boxcounter{ 0 };

	while (std::getline(inf, row)) {
		std::istringstream iss(row);
		std::string xyz{};
		Box tempBox{};
		int counter{ 0 };
		while (std::getline(iss, xyz, ',')) {
			if (counter == 0) {
				tempBox.x = std::stoi(xyz);
			}
			else if (counter == 1) {
				tempBox.y = std::stoi(xyz);
			}
			else {
				tempBox.z = std::stoi(xyz);
			}
			counter++;
		}
		Boxes.resize(Boxcounter + 1, tempBox);
		Boxcounter++;
	}
	std::vector<std::vector<double>> distances(Boxes.size(), std::vector<double>(Boxes.size(), 1000000));
	for (size_t i = 0; i < Boxes.size(); i++) {
		for (size_t j = 0; j < Boxes.size(); j++) {
			if (i != j) {
				distances[i][j] = calcDistance(Boxes[i], Boxes[j]);
			}
			//std::cout << distances[i][j]<<" ";
		}
		//std::cout << '\n';
	}
	std::vector<std::vector<size_t>> circuits;
	for (size_t p = 0; p < 1000; p++) {
		auto [i, j] = shortestDistance(distances);
		distances[i][j] = 1000000;
		distances[j][i] = 1000000;
		if (circuits.size() == 0) {
			circuits.resize(1, { i,j });
		}
		else {
			//Check if boxes are in a circuit yet.
			bool temp{ false };
			if (circuits.size() > 1) {
				
				for (size_t q = 0; q < circuits.size(); q++) {
					if (std::count(circuits[q].begin(), circuits[q].end(), i) &&!std::count(circuits[q].begin(), circuits[q].end(), j)) {
						circuits[q].resize(circuits[q].size() + 1, j);
						temp = true;
						break;
					}
					else if (std::count(circuits[q].begin(), circuits[q].end(), j) && !std::count(circuits[q].begin(), circuits[q].end(), i)) {
						circuits[q].resize(circuits[q].size() + 1, i);
						temp = true;
						break;
					}

				}
			}
			else {
				if (std::count(circuits[0].begin(), circuits[0].end(), i) && !std::count(circuits[0].begin(), circuits[0].end(), j)) {
					circuits[0].resize(circuits[0].size() + 1, j);
					temp = true;
				}
				else if (std::count(circuits[0].begin(), circuits[0].end(), j) && !std::count(circuits[0].begin(), circuits[0].end(), i)) {
					circuits[0].resize(circuits[0].size() + 1, i);
					temp = true;
				}
			}
			if (!temp) {
				circuits.resize(circuits.size() + 1, { i, j });
			}
		}
	}
	int changes{ 1 };
	while (changes != 0) {
		changes = 0;
		for (size_t i = 0; i < circuits.size(); i++) {
			for (size_t j = 0; j < circuits.size(); j++) {
				if (i != j) {
					if (commonElement(circuits[i], circuits[j])) {
						std::vector<size_t> tempvector{ combine(circuits[i], circuits[j]) };
						if (i > j) {
							circuits.erase(circuits.begin() + i);
							circuits.erase(circuits.begin() + j);
						}
						else {
							circuits.erase(circuits.begin() + j);
							circuits.erase(circuits.begin() + i);
						}
						circuits.resize(circuits.size() + 1, tempvector);
						changes++;
						break;
					}
				}
			}
		}
	}

	std::cout << findXlargestandMultiply(circuits,3);


	return 0;
}
