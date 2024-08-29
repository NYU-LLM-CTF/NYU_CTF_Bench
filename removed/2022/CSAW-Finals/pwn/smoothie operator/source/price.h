#ifndef PRICE
#define PRICE

#include <stdlib.h>
#include <iostream>

bool check_integer(char onechar) {
    return (onechar >= '0' && onechar <= '9');
}

class Price {
    private:
    uint32_t dollars;
    uint32_t cents;

    public: 
    Price() : dollars(0), cents(0) {}
    Price(uint32_t _dollars, uint32_t _cents);
    Price(const Price& other) { dollars = other.dollars; cents = other.cents; }
    Price(const Price*& other) { dollars = other->dollars; cents = other->cents; }
    friend std::ostream & operator << (std::ostream &out, const Price &p);
    friend std::istream & operator >> (std::istream &in,  Price &p);
    bool is_empty() { return (dollars == 0 && cents == 0); } 
};

Price::Price(uint32_t _dollars, uint32_t _cents) {
    dollars = _dollars + (_cents / 100);
    cents = _cents % 100;
}

std::istream & operator>>(std::istream& ins, Price& p) {
    p.dollars = 0;
    p.cents = 0;

    std::string d;
    std::string c;
    char onechar;
    bool period = false;

    ins.get(onechar);

    while (1) {
        if (onechar == '\n') break;
        if (onechar == '.') {
            period = true;
            ins.get(onechar);
            continue;
        }
        if (check_integer(onechar) == false) goto fail;

        if (!period) d.push_back(onechar);
        else         c.push_back(onechar);
        
        ins.get(onechar);
    }

    if (c.length() == 1 || c.length() > 2) goto fail;

    if (d.length() == 0) p.dollars = 0;
    else p.dollars = atoi(d.c_str());
    if (c.length() == 0) p.cents = 0;
    else p.cents = atoi(c.c_str());
    return ins;

    fail:
        p.dollars = 0;
        p.cents = 0;
        return ins;
}

std::ostream & operator<<(std::ostream& out, const Price &p) {
    out << "$" << p.dollars << ".";
    printf("%02d\n", p.cents);
    return out;
}

#endif