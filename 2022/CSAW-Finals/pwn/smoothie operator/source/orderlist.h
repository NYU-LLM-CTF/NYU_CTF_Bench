#ifndef ORDERLIST
#define ORDERLIST

#include <stdlib.h>
#include <iostream>
#include <string.h>

class OrderList {
    protected: 
    std::vector<std::shared_ptr<Order>> list;

    public:
    OrderList() { list.reserve(40); };
    friend std::ostream& operator<<(std::ostream& out, const OrderList& o); 
    int add_order(Order* o);
    int add_order(std::shared_ptr<Order> o);
    int edit_order_by_num(uint32_t n);
    std::shared_ptr<Order> prepare(uint32_t n);
    std::shared_ptr<Order> serve(uint32_t n);
    ORDER_STATE delete_order(uint32_t n);
};

int OrderList::add_order(Order* o) {
    uint32_t n = o->get_number();
    for (auto i : list) {
        if (n == i.get()->get_number()) {
            std::cout << "\n[ ERROR ] : duplicate order number\n";
            std::cout << "Please try again with a new order number\n";
            return -1;
        }
    }
    std::shared_ptr<Order> p(o);
    list.push_back(p);
    return 0;
}

int OrderList::add_order(std::shared_ptr<Order> o) {
    uint32_t n = o.get()->get_number();
    for (auto i : list) {
        if (n == i.get()->get_number()) {
            std::cout << "\n[ ERROR ] : duplicate order number\n";
            std::cout << "Please try again with a new order number\n";
            return -1;
        }
    }
    std::shared_ptr<Order> p(o); // to do check this, should this be makeshared? 
    list.push_back(p);
    return 0;
}

int OrderList::edit_order_by_num(uint32_t n) {
    for (int i = 0; i < list.size(); i++) {
        if (n == list[i].get()->get_number()) {
            list[i].get()->edit_order();
            return 0;
        }
    }
    std::cout << "\n[ERROR] : no order found with that number\n";
    return -1;
}

ORDER_STATE OrderList::delete_order(uint32_t n) {
    for (int i = 0; i < list.size(); i++) {
        if (n == list[i].get()->get_number()) {
            ORDER_STATE s = list[i].get()->get_state();
            list.erase(list.begin() + i);
            return s;
        }
    }
    std::cout << "[ ERROR ] : no order found with that number\n";
    return STATE_NONE;
}

std::shared_ptr<Order> OrderList::prepare(uint32_t n) {
    for (int i = 0; i < list.size(); i++) {
        if (n == list[i].get()->get_number()) {
            ORDER_STATE s = list[i].get()->get_state();
            // update state. Caller must remove from list if relevant with delete_order()
            if (s == STATE_ORDERED) {
                std::shared_ptr<Order> o = list[i];
                list[i].get()->set_state(STATE_PREPPED);
                return o;   
            }
            // invalid state
            return NULL;
        }
    }
    std::cout << "\n[ ERROR ] : no order found with that number\n";
    return NULL;
} 

std::shared_ptr<Order> OrderList::serve(uint32_t n) {
    for (int i = 0; i < list.size(); i++) {
        if (n == list[i].get()->get_number()) {
            ORDER_STATE s = list[i].get()->get_state();
            // delete from this list, caller handles adding to new list
            if (s == STATE_PREPPED) {
                std::shared_ptr<Order> o = list[i];
                list[i].get()->set_state(STATE_SERVED);
                return o;   
            }
            // invalid state
            return NULL;
        }
    }
    std::cout << "\n[ ERROR ] : no order found with that number\n";
    return NULL;
} 

std::ostream& operator<<(std::ostream& out, const OrderList& o) {
    for (auto i : o.list) {
        out << *i.get() << std::endl;
    }
    return out;
}

#endif