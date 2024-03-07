#include <vector>
#include <iostream>
#include <memory>
#include <cstring>
#include <vector>
#include <string>
#include "smoothie.h"
#include "monster.h"
#include "price.h"
#include "orderlist.h"
#include "pastry.h"
#include "complaints.h"

void get_option(short* in) {
    std::cin >> *in;
    getc(stdin); // clean newline
}

uint32_t get_order_number() {
    uint32_t n;
    char c;
    std::cout << "  Please enter order number\n";
    std::cout << "  > ";
    std:: cin >> n;
    c = getc(stdin); // consume trailing newline
    return n;
}

uint32_t get_complaint_number() {
    uint32_t n;
    char c;
    std::cout << "  Please enter complaint number\n";
    std::cout << "  > ";
    std:: cin >> n;
    c = getc(stdin); // consume trailing newline
    return n;
}

uint8_t get_order_choice() {
    char c;
    uint8_t choice;
    while (1) {
        std::cout << std::endl;
        std::cout << "Please choose an order type:\n\n";
        std::cout << "  1. Smoothie\n";
        std::cout << "  2. Monster\n";
        std::cout << "  3. Pastry\n";
        std::cout << "  > ";
        std::cin >> c;
        choice = (int)strtol(&c, NULL, 10);
        c = getc(stdin); // consume trailing newline
        if (choice > 0 && choice <= 3) break;
        std::cout << "\n[ERROR] : please choice a valid option\n";
    }
    return choice;
}

uint8_t menu() {
    char c[4];
    char _c;
    uint8_t choice;

    while (1) {
        std::cout << std::endl;
        std::cout << "Please choose an action:\n\n";
        std::cout << "  1. Print queue\n";
        std::cout << "  2. Add order\n";
        std::cout << "  3. Edit order\n";
        std::cout << "  4. Prep order\n";
        std::cout << "  5. Serve order\n";
        std::cout << "  6. Cancel order\n";
        std::cout << "  7. Print complaints\n";
        std::cout << "  8. File complaint\n";
        std::cout << "  9. Resolve complaint\n";
        std::cout << "  10. Edit complaint\n";
        std::cout << "  11. Exit\n";
        std::cout << "  > ";
        std::cin >> c;
        choice = (int)strtol(c, NULL, 10);
        _c = getc(stdin); // consume trailing newline
        if (choice > 0 && choice <= 11) break;
        std::cout << "\n[ERROR] : please choice a valid option\n";
    }
    return choice;
}

int main () {
    setvbuf(stdout, NULL, _IONBF, 0);
    setvbuf(stdin,  NULL, _IONBF, 0);

    std::cout << "Welcome to Smoothie Operator, your favorite smoothie shop simulation game!\n";
    std::cout << "How do you win, you ask? ";
    std::cout << "You can't! You just play forever serving delicious food to your needy patrons!\n";
    std::cout << "Let's begin!\n\n";

    OrderList main;
    OrderList ordered;
    OrderList prepped;
    OrderList served;
    ComplaintList complaints;

    uint8_t choice = 0;
    uint32_t order_number = 0;
    ORDER_STATE state = STATE_NONE;
    std::shared_ptr<Order> new_o = NULL;
    std::shared_ptr<Order> ret_o = NULL;
    Smoothie* new_smooth = NULL;
    Monster* new_monster = NULL;
    Pastry* new_pastry = NULL;

    while (1) {
        choice = menu();
        switch(choice) {
        case 1:
            std::cout << "\n------- ORDER LIST ------\n\n";
            std::cout << main;
            std::cout << "-------------------------\n";
            break;
        case 2:
            choice = get_order_choice();
            switch(choice) {
            case SMOOTHIE_ORDER: 
                new_smooth = new Smoothie();
                new_smooth->create_order();
                new_o = std::make_shared<Smoothie>(new_smooth);
                delete new_smooth;
                break;
            case MONSTER_ORDER:
                new_monster = new Monster();
                new_monster->create_order();
                new_o = std::make_shared<Monster>(new_monster);
                delete new_monster;
                break;
            case PASTRY_ORDER:
                new_pastry = new Pastry();
                new_pastry->create_order();
                new_o = std::make_shared<Pastry>(new_pastry);
                delete new_pastry;
                break;
            }
            // o->set_priority(1);
            // store first created pointer in the main list 
            if (main.add_order(new_o) != -1) {
                ordered.add_order(new_o);
            }
            new_o = NULL;

            break;
        case 3: // edit order
            order_number = get_order_number();
            main.edit_order_by_num(order_number);
            break;
        case 4: // prep order
            order_number = get_order_number();
            ret_o = ordered.prepare(order_number);
            if (ret_o != NULL) {
                state = ret_o.get()->get_state();
                switch (state) {
                case STATE_NONE:
                    break;
                case STATE_ORDERED:
                    // should never be in this state
                    break;
                case STATE_PREPPED:
                    prepped.add_order(ret_o);
                    ret_o = NULL;
                    printf("%ld\n", ret_o.use_count());
                    ordered.delete_order(order_number);
                    break;
                case STATE_SERVED:
                    // should never be in this state
                    break; 
                }
            }
            break;
        case 5: // serve order
            order_number = get_order_number();
            ret_o = prepped.serve(order_number);
            if (ret_o != NULL) {
                state = ret_o.get()->get_state();
                switch (state) {
                case STATE_NONE:
                    break;
                case STATE_ORDERED:
                    // should never be in this state
                    break;
                case STATE_PREPPED:
                    // should never be in this state
                    break;
                case STATE_SERVED:
                    served.add_order(ret_o);
                    ret_o = NULL;
                    printf("%ld\n", ret_o.use_count());
                    prepped.delete_order(order_number);
                    break; 
                }
            }
            break;
        case 6: // cancel order
            order_number = get_order_number();
            state = main.delete_order(order_number);
            switch (state) {
            case STATE_NONE:
                break;
            case STATE_ORDERED:
                ordered.delete_order(order_number);
                break;
            case STATE_PREPPED:
                prepped.delete_order(order_number);
                break;
            case STATE_SERVED:
                served.delete_order(order_number);
                break; 
            }
            break;
        case 7: // print complaints
            std::cout << complaints;
            break;
        case 8:
            complaints.add_complaint();
            break;
        case 9: // resolve complaint
            order_number = get_complaint_number();
            complaints.delete_complaint(order_number);
            break;
        case 10: // edit complaint
            order_number = get_complaint_number();
            complaints.edit_complaint(order_number);
            break;
        case 11:
            return 0;
        }
    }
    // Monster* c = new Monster;
    // c->create_order();
    // Smoothie* s = new Smoothie;
    // s->create_order();

    // list.add_order(s);
    // list.add_order(c);
    return 0;
}