#ifndef MONSTER
#define MONSTER

#include <stdlib.h>
#include <iostream>
#include "order.h"
#include <vector>
#include <string>

const uint8_t ARRSIZE = 7;

const std::string FLAVORS[ARRSIZE] { 
    "Regular (gross)",
    "Ultra White",
    "Ultra Blue",
    "Ultra Fiesta",
    "Ultra Black",
    "Ultra Sunrise",
    "Ultra Violet",
};

class Monster : public Order {
    private:
    uint32_t buffer;
    uint32_t buffer2 ;
    uint32_t quantities[ARRSIZE];

    public:
    Monster() { price = Price();}
    Monster(Monster& other) { 
        price = Price(other.price);
        memcpy(quantities, other.quantities, sizeof(quantities));
        number = other.number;
        state = other.state;
        buffer = 0x20; 
    }
    Monster(Monster*& other) { 
        price = Price(other->price);
        memcpy(quantities, other->quantities, sizeof(quantities));  
        number = other->number;
        state = other->state;
    }
    void get_params();
    void edit_params();
    void print_params(std::ostream& out) const;
    std::string get_type() const { return "Monster (TM)"; }
};


void Monster::get_params() {
    std::cout << "Choose y/n and enter a quantity for each Monster (TM) type\n";

    int i = 0;
    char in;
    int qty;
    while (i < ARRSIZE) {
        qty = 0;
        std::cout << "Would you like any " << FLAVORS[i] << "? ";
        std::cin >> in;
        if (in == 'y') {
            std::cout << "How many would you like? ";
            std::cin >> quantities[i];
        }
        i++;
    }
}

void Monster::edit_params() {
    long long n;

    n = 0;
    for (; n < ARRSIZE; n++) 
        std::cout << n + 1 << ". " << FLAVORS[n] << std::endl;

    printf("Choose an flavor to edit: ");
    std::cin >> n;
    if (n < 0) goto fail;
    else {
        // vuln here - logic sequence error
        // entering index 0 allows an OOB write at quantities[0xff]
        n--;
        long long s = ARRSIZE;
        if (n < s) {
            std::cout << "Enter a new quantity: ";
            std::cin >> quantities[(uint8_t)n];
            return;
        }
        else { goto fail; }
    }
    
    fail:
        std::cout << "[ ERROR ] : invalid flavor index\n";
        return;
}

void Monster::print_params(std::ostream& out) const {
    out << "Order quantities: \n";
    int j = 0;
    for (auto i : quantities) {
        out << FLAVORS[j] << ": " << i << std::endl;
        j++;
    }
}

#endif