#ifndef SMOOTHIE
#define SMOOTHIE

#include <stdlib.h>
#include <iostream>
#include "order.h"
#include <vector>
#include <string>

enum SMOOTHIE_SIZE : uint32_t {
    LARGE,
    MEDIUM,
    SMALL,
};

class Smoothie : public Order {
    private:
    std::vector<std::string> ingredients;
    SMOOTHIE_SIZE smoothie_size;
    bool protein_powder;
    uint32_t num_avocados;
    
    public:
    Smoothie() { price = Price(); }
    Smoothie(Smoothie& other) { 
        price = Price(other.price);
        ingredients = std::vector<std::string>(other.ingredients); 
        number = other.number;
        state = other.state;
        smoothie_size = other.smoothie_size;
        protein_powder = other.protein_powder;
        num_avocados = other.num_avocados;
    }
    Smoothie(Smoothie*& other) { 
        price = Price(other->price);
        ingredients = std::vector<std::string>(other->ingredients); 
        number = other->number;
        state = other->state;
        smoothie_size = other->smoothie_size;
        protein_powder = other->protein_powder;
        num_avocados = other->num_avocados;
    }
    void get_params();
    void edit_params();
    void print_params(std::ostream& out) const;
    std::string get_type() const { return "smoothie"; }
};

void Smoothie::get_params() {
    std::string current;
    std::vector<std::string>() = ingredients;
    std::cout << "Enter up to 10 ingredients separated by a new line\n";
    std::cout << "Enter '0' when finished\n";
    
    for (int i = 0; i < 10; i++) {
        getline(std::cin, current);
        if (current.compare("0") == 0) break;
        if (current.compare("\n") == 0) {
            std::cout << "Invalid ingredient, please try again\n";
            i--;
            continue;
        }
        ingredients.push_back(current);
    }

    uint32_t s;
    while (1) {
        std::cout << "Size (1 for Small, 2 for Medium, 3 for Large)?\n";
        std::cin >> s;
        if (s > 0 && s < 4) break;
        std::cout << "[ ERROR ] : please enter a valid size\n";
    }
    switch (s) {
    case 1:
        smoothie_size = SMALL;
        break;
    case 2:
        smoothie_size = MEDIUM;
        break;
    case 3:
        smoothie_size = LARGE;
        break;
    }

    while (1) {
        std::cout << "Protein powder (1 for yes, 0 for no)?\n";
        std::cin >> s;
        if (s == 1 || s == 0) break;
        std::cout << "[ ERROR ] : please enter a valid size\n";
    }
    switch(s) {
    case 0: protein_powder = false; break;
    case 1: protein_powder = true;  break;
    }

    std::cout << "Number of avocados (max 4294967296)?\n";
    std::cin >> num_avocados;
}

void Smoothie::edit_params() {
    get_params();
}

void Smoothie::print_params(std::ostream& out) const {
    out << "Ingredients:\n";
    int j = 1;
    for (auto i : ingredients) { out << "  " << j << ". " << i << std::endl; j++; }
    out << "Size: ";
    switch(smoothie_size) {
        case SMALL: out << "small\n"; break;
        case MEDIUM: out << "medium\n"; break;
        case LARGE: out << "large\n"; break;
    }
    out << "Protein Powder: ";
    switch(protein_powder) {
        case true: out << "yes\n"; break;
        case false: out << "no\n"; break;
    }
    out << "Number of avocados: " << num_avocados << std::endl;
}

#endif