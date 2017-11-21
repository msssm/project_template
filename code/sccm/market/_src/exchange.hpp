#ifndef EXCHANGE_HPP_
#define EXCHANGE_HPP_

#include<map>
#include<queue>
#include"order.hpp"

template <class O>
struct Book{
    using OrderMap = std::map<O::id_type, O>;
    using elem_type = std::pair<O::price_type, O::index_type>;
    using comparator;
    auto cmp = [](const elem_type& l, const elem_type r) { return comparator(l.first, r.first);};
    using IndexHeap = std::priority_queue<O::price_type, std::vector<elem_type>, cmp>;
    using IndexQueue = std::queue<O::id_type>
    void insert(O o){
        orders.insert(o);
        sortindex.push(elem_type(o.limit_price, o.id));
        oldindex.push(o.id);
    }
    
    void remove_old:
    
    OrderMap orders;
    IndexQueue oldindex;
    IndexHeap sortindex;
    
}
template<> struct Book<Order<Order::Kind.Sell>>{
    using comparator = std::greater<O::id_type>;
}
template<> struct Book<Order<Order::Kind.Buy>>{
    using comparator = std::less<O::id_type>;
}

class Exchange{
    using price_type = Order::price_type;
    using time_type = Order::time_type;
    using id_type = Order::id_type;
    Book sellorders();
    Book buyorders();
    template <class O>
    void insert(O){};
    
}

template <> Exchange::insert<Order<Order::Kind.Sell>>(Order<Order::Kind.Sell> o){
    sellorders.insert(o);
}
template <> Exchange::insert<Order<Order::Kind.Buy>>(Order<Order::Kind.Buy> o){
    buyorders.insert(o);
}

#endif
