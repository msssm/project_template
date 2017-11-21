#ifndef ORDER_HPP_
#define ORDER_HPP_
enum Kind {Sell, Buy};

template <Kind k>
struct Order{
    using Kind = Kind;
    using cash_type = double;
    using bitcoin_type = double;
    using amount_type;
    using price_type = decltype(cash_type()/bitcoin_type());
    using time_type = std::size_t;
    using id_type = std::size_t;
    static id_type unique_id_counter = 0;
    static id_type get_new_id(){
        return unique_id_counter++;
    }
    Order(amount_type amount_, price_type plim, time_type tp,  time_type te, id_type a_id) : id(get_new_id()), agent_id(a_id), amount(amount_), residual(amount_), t_expire(te), t_placed(tp), limit_price(plim){}

    id_type id;
    id_type agent_id;
    amount;
    residual;
    time_type t_expire;
    time_type t_placed;
    price_type limit_price;
};

template <> struct Order<Kind.Sell>{
    using amount_type = bitcoin_type;
}

template <> struct Order<Kind.Buy>{
    using amount_type = cash_type;
}

#endif
