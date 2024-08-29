#include <iostream>
#include <fstream>
#include <functional>
#include <vector>
#include <utility>
#include <tuple>
#include <algorithm>
#include <iterator>
#include <cmath>
#include <cstdlib>

enum ObjType
{
    Val,
    Func
};

template<class T>
T unboxT(void* v)
{
    return reinterpret_cast<T>(v);
}

template<class T>
void* boxT(T v)
{
    return reinterpret_cast<void*>(v);
}

class Function
{
    std::function<void*(std::vector<void*>)> m_ptr;
    int m_argcount;

public:
    Function(std::function<void*(std::vector<void*>)> ptr, int argcount)
        :m_ptr(ptr), m_argcount(argcount) {}

    void* operator()(std::vector<void*> args)
    {
        return m_ptr(args);
    }

    int numArgs() const
    {
        return m_argcount;
    }
};

auto unbox = unboxT<unsigned long>;
auto box   = boxT<unsigned long>;

auto unboxF = unboxT<Function*>;
auto boxF   = boxT<Function*>;

void apply(std::vector<std::tuple<ObjType, void*>> &stk)
{
    for (int i = stk.size() - 1; i >= 0; --i)
    {
        auto v = stk[i];
        if (std::get<0>(v) == ObjType::Func)
        {
            auto f = unboxF(std::get<1>(v));
            int arg_count = f->numArgs();
            std::vector<void*> args = {};
            if (i + 1 + arg_count > stk.size())
            {
                std::cerr << "oof\n";
                return;
            }
            std::transform(stk.begin()+i+1, stk.begin()+i+1+arg_count, std::back_inserter(args),
                    [](std::tuple<ObjType, void*> a) -> void* { return std::get<1>(a); });
            stk.insert(stk.begin() + i, std::make_tuple(ObjType::Val, f->operator()(args)));
            stk.erase(stk.begin() + i + 1, stk.begin() + i + 2 + arg_count);
        }
    }
}

unsigned long validate()
{

    std::function<void*(std::vector<void*>)> if1 = [&](std::vector<void*> args) -> void*
    {
        auto x = unbox(args.data()[0]);
        if (x < 4)
            return box(x);
        if (x % 2 == 0)
            args[0] = box(x/2);
        else
            args[0] = box(x+3);
        return box(x + unbox(if1(std::move(args))));
    };

    std::function<void*(std::vector<void*>)> if2 = [&](std::vector<void*> args) -> void*
    {
        auto x = unbox(args.data()[0]);
        if (x < 2)
            return box(x);
        args[0] = box(x/5);
        return box(x + unbox(if2(std::move(args))));
    };

    std::function<void*(std::vector<void*>)> if3 = [&](std::vector<void*> args) -> void*
    {
        auto x = unbox(args.data()[0]);
        auto y = unbox(args.data()[1]);

        return box(x^y);
    };

    std::function<void*(std::vector<void*>)> if4 = [&](std::vector<void*> args) -> void*
    {
        auto x = unbox(args.data()[0]);

        return box(std::sqrt(x));
    };

    std::function<void*(std::vector<void*>)> if5 = [&](std::vector<void*> args) -> void*
    {
        auto x = unbox(args.data()[0]);
        auto y = unbox(args.data()[1]);

        *(int*)x = y;
        return box(x*y);
    };

    auto f1 = Function(if1, 1);
    auto f2 = Function(if2, 1);
    auto f3 = Function(if3, 2);
    auto f4 = Function(if4, 1);
    auto f5 = Function(if5, 2);

    std::vector<std::tuple<ObjType, void*>> pstack;
    pstack.push_back(std::make_tuple(ObjType::Func, boxF(&f3)));
    pstack.push_back(std::make_tuple(ObjType::Func, boxF(&f1)));
    pstack.push_back(std::make_tuple(ObjType::Func, boxF(&f3)));
    pstack.push_back(std::make_tuple(ObjType::Val, box(42069)));
    pstack.push_back(std::make_tuple(ObjType::Val, box(13371337)));

    unsigned long num;
    while (std::cin >> num)
    {
        if (num == 0xf1)
            pstack.push_back(std::make_tuple(ObjType::Func, boxF(&f1)));
        else if (num == 0xf2)
            pstack.push_back(std::make_tuple(ObjType::Func, boxF(&f2)));
        else if (num == 0xf3)
            pstack.push_back(std::make_tuple(ObjType::Func, boxF(&f3)));
        else if (num == 0xf4)
            pstack.push_back(std::make_tuple(ObjType::Func, boxF(&f4)));
        else if (num == 0xf5)
            pstack.push_back(std::make_tuple(ObjType::Func, boxF(&f5)));
        else
            pstack.push_back(std::make_tuple(ObjType::Val, box(num)));
    }

    apply(pstack);

    std::cout << unbox(std::get<1>(pstack.back()));

    return 0;
}

void success()
{
    std::ifstream f;
    f.rdbuf()->pubsetbuf(0,0);
    f.open("flag.txt");
    if (!f)
    {
        std::cout << "no flag.txt file\n";
        return;
    }
    std::string out;
    f >> out;
    std::cout << out << std::endl;
    f.close();
}

int main()
{
    if (validate() == 1337)
    {
        success();
    }
}
