#ifndef ORDER
#define ORDER

#include <stdlib.h>
#include <iostream>
#include <string.h>
#include "price.h"

enum ORDER_TYPE : uint32_t {
    SMOOTHIE_ORDER = 1,
    MONSTER_ORDER = 2,
    PASTRY_ORDER = 3
};

enum ORDER_STATE {
    STATE_NONE = 0,
    STATE_ORDERED = 1,
    STATE_PREPPED = 2,
    STATE_SERVED = 3
};

std::ostream& print_state(std::ostream& out, enum ORDER_STATE s) {
    out << "State: ";
    switch(s) {
    case STATE_NONE:
        out << "None\n";
        break;
    case STATE_ORDERED: 
        out << "Ordered\n";
        break;
    case STATE_PREPPED:
        out << "Prepared\n";
        break;
    case STATE_SERVED:
        out << "Served\n";
        break;
    }
    return out;
}

class Order {
    protected: 
    uint32_t number;
    Price price;
    uint64_t PAD;
    ORDER_STATE state;

    public:
    Order() : number(0) { price = Price(); }
    Order(uint32_t _number, Price _price) : 
        number(_number), price(_price) {}
    Order(uint32_t _number, uint32_t _dollars, uint32_t _cents) : 
        number(_number) { price = Price(_dollars, _cents); 
        
    }
    Order(Order*& other) { 
        price = Price(other->price);
        state = other->state;
        number = other->number;
    }
    friend std::ostream& operator<<(std::ostream& out, const Order& o); 
    friend std::istream& operator>>(std::istream& ins, Order& o); 
    Price get_price() const { return price;}
    ORDER_STATE get_state() const { return state;}
    void set_state(enum ORDER_STATE p) { state = p; }
    uint32_t get_number() const { return number; }
    Order* create_order();
    Order* edit_order();
    virtual void get_params() = 0;
    virtual void edit_params() = 0;
    virtual void print_params(std::ostream& out) const = 0; 
    virtual std::string get_type() const = 0;
};

std::istream & operator>>(std::istream& ins, Order& o) {
    o.number = 0;

    std::string n;
    getline(std::cin, n);
    if (n.length() == 0) return ins;

    o.number = atoi(n.c_str());
    return ins;
}

Order* Order::create_order() {
    std::cout << "\nCreating " << get_type() << " order!\n";
    while (1) {
        std::cout << "Enter price (dollars.cents): $";
        std::cin >> price;

        if (!price.is_empty()) break;
        else printf("\n[ERROR] : invalid price\n");
    }

    while (1) {
        std::cout << "Enter order number: #";
        std::cin >> number;
        getc(stdin); // consume trailing '\n'
        if (number != 0) break;
        printf("\n[ERROR] : invalid order nubmer\n");
    }

    get_params();

    state = STATE_ORDERED;
    return this;
}

Order* Order::edit_order() {
    std::cout << "\nEditing " << get_type() << " order!\n";
    while (1) {
        std::cout << "Enter price: $";
        std::cin >> price;

        if (!price.is_empty()) break;
        else printf("\n[ERROR] : invalid price\n");
    }

    edit_params();

    return this;
}

std::ostream& operator<<(std::ostream& out, const Order& o) {
    out << "Order: #" << o.number << std::endl;
    out << "Type: " << o.get_type() << std::endl;
    out << "Price: " << o.price;
    print_state(out, o.get_state());
    o.print_params(out);
    return out;
}

#endif