#include <iostream>
#include <string>
#include <cstdio>

void init()
{
    std::setbuf(stdin, NULL);
}

int check(const std::string& s)
{
    int hm[] = {102, 110, 101, 103, 131, 114, 59, 114, 128, 95, 69, 113, 95, 134, 138, 74, 112, 114, 51, 138, 95, 57, 142, 95, 130, 70, 132, 134, 75, 150, 95, 77, 110, 159, 56, 58, 52, 54, 56, 58, 68, 70, 129};

    int sum = 1;
    for (int i = 0; i < s.length(); ++i)
    {
        if ((i ^ s[i])+i != hm[i])
            sum = 0;
    }
    return sum;
}

int main()
{
    init();
    std::string x;

    std::cout << "help me" << std::endl;;

    std::cin >> x;

    if (check(x))
    {
        std::cout << "you found me!" << std::endl;
    }

    return 0;
}
