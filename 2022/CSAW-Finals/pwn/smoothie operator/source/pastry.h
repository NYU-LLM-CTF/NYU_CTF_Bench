#ifndef PASTRY
#define PASTRY

#include <stdlib.h>
#include <iostream>
#include "order.h"
#include <vector>
#include <string>

const std::string PASTRY_TYPES[10] = {
    "Cannoli (TM)",
    "muffin",
    "eclair",
    "doughnut",
    "Danish",
    "croissant",
    "scone",
    "tart",
    "cinnamon roll",
    "biscotti"
};

class Pastry : public Order {
    private:
    std::vector<uint32_t> quantities;

    public:
    // mistake here - this leaves the UAF accessible after 
    // a shared_ptr<Pastry> is eliminated
    // ~Pastry() {
    //     delete quantities;
    // }
    Pastry() { 
        price = Price(); 
        quantities.reserve(10);
    }
    Pastry(Pastry& other) { 
        price = Price(other.price);
        quantities.reserve(10);
        quantities.insert(quantities.begin(), 
            other.quantities.begin(), other.quantities.end());      
        number = other.number;
        state = other.state;
    }
    Pastry(Pastry*& other) { 
        price = Price(other->price);
        quantities.reserve(10);
        quantities.insert(quantities.begin(), 
            other->quantities.begin(), other->quantities.end());      
        number = other->number;
        state = other->state;
    }
    void get_params();
    void edit_params();
    void print_params(std::ostream& out) const;
    std::string get_type() const { return "pastry"; }
};

void Pastry::get_params() {
    std::cout << "Choose y/n and enter a quantity for each pastry type\n";

    int i = 0;
    char in;
    int qty;
    while (i < 10) {
        qty = 0;
        std::cout << "Would you like any " << PASTRY_TYPES[i] << "? ";
        std::cin >> in;
        if (in == 'y') {
            std::cout << "How many would you like? ";
            std::cin >> qty;
        }
        quantities.push_back(qty);
        i++;
    }
}

void Pastry::edit_params() {
    long long n;

    n = 0;
    for (; n < 10; n++) 
        std::cout << n + 1 << ". " << PASTRY_TYPES[n] << std::endl;

    printf("Choose an pastry to edit: ");
    std::cin >> n;
    if (n < 0) goto fail;
    else {
        // same vuln as in the Monster class 
        // entering index 0 allows an OOB write at quantities[0xff]
        n--;
        long long s = quantities.size();
        if (n < s) {
            std::cout << "Enter a new quantity: ";
            std::cin >> quantities[(uint8_t)n];
            return;
        }
        else { goto fail; }
    }
    
    fail:
        std::cout << "[ ERROR ] : invalid pastry index\n";
        return;
}

void Pastry::print_params(std::ostream& out) const {
    out << "Order quantities: \n";
    int j = 0;
    for (auto i : quantities) {
        out << PASTRY_TYPES[j] << ": " << i << std::endl;
        j++;
    }
}

#endif