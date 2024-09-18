#include <iostream>
#include <cstdlib>

class Action
{
    char m_s;
    unsigned char m_x, m_y;
    Action* m_next = nullptr;

public:
    Action(char s, unsigned char x, unsigned char y) :m_s(s), m_x(x), m_y(y) {}

    void set_next(Action* next)
    {
        m_next = next;
    }

    friend void display(Action*);
};

void learning_pointers_pls_ignore()
{
    int a = 1;
    int *b = &a;
    int **c = &b;
    **c = 2;
}

void display(Action* event)
{
    char grid[10][10];
    Action* curr = event;
    while (curr != nullptr)
    {
        grid[curr->m_x][curr->m_y] = curr->m_s;
        curr = curr->m_next;
    }
    std::cout << "Displaying\n";
    for (int i = 0; i < 10; ++i)
    {
        for (int j = 0; j < 10; ++j)
        {
            std::cout << grid[i][j];
        }
        std::cout << "\n";
    }
}

void play()
{
    char shape = '+';
    int x = 0, y = 0;

    Action *head = new Action('+', 0, 0);
    Action *current = head;

    for (int i = 0; i < 100; ++i)
    {
        std::cout << "shape> ";
        std::cin >> shape;

        if (shape == 'd')
        {
            learning_pointers_pls_ignore();
            display(head);
            continue;
        }

        std::cout << "loc> ";
        std::cin >> x >> y;

        std::cout << "placing " << shape << " at " << x << ", " << y << std::endl;

        Action *event = new Action(shape, x, y);
        current->set_next(event);
        current = event;
    }
}

void init()
{
    setbuf(stdout, NULL);
}

int main()
{
    init();
    play();

    return 0;
}
