#ifndef COMPLAINTS
#define COMPLAINTS

#include <vector>
#include <string>
#include <stdlib.h>
#include <iostream>

class ComplaintList {
    std::vector<std::string*> list;

public:
    ComplaintList() { list.reserve(40); };
    friend std::ostream& operator<<(std::ostream& out, const ComplaintList& o); 
    void add_complaint();
    void delete_complaint(uint32_t n);
    void edit_complaint(uint32_t n);
};

void ComplaintList::add_complaint() {
    std::string* s = new std::string();
    printf("Please enter your complaint:\n");
    std::cin >> *s;
    s->shrink_to_fit(); // save space (and allow easier heap feng shui)
    list.push_back(std::move(s));
}

void ComplaintList::delete_complaint(uint32_t n) {
    n--;
    if (n < list.size()) {
        std::string* s = list.at(n);
        list.erase(list.begin() + n);
        delete s;
        printf("Complaint %d resolved!\n", n + 1);
        return;
    }
    printf("\n[ERROR] : no complaint found with that number\n");
}

void ComplaintList::edit_complaint(uint32_t n) {
    n--;
    if (n < list.size()) {
        std::string* s = list.at(n);
        printf("Enter the updated complaint:\n");
        std::cin >> *s;
        printf("Complaint %d edited!\n", n + 1);
        return;
    }
    printf("\n[ERROR] : no complaint found with that number\n");
}

std::ostream& operator<<(std::ostream& out, const ComplaintList& o) {
    out << "Complaints: \n";
    int j = 1;
    for (auto i : o.list) {
        out << j << ": " << *i << std::endl;
        j++;
    }
    return out;
}

#endif