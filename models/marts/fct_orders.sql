with

orders as (

    select * from {{ ref('stg_orders') }}

),

order_items as (

    select * from {{ ref('order_items') }}

),

order_items_summary as (

    select

        order_items.order_id,

        sum(order_items.supply_cost) as order_cost,
        sum(order_items.is_food_item) as count_food_items,
        sum(order_items.is_drink_item) as count_drink_items


    from order_items

    group by 1

),


compute_booleans as (
    select

        orders.*,
        order_cost,
        count_food_items > 0 as is_food_order,
        count_drink_items > 0 as is_drink_order

    from orders

    left join
        order_items_summary
        on orders.order_id = order_items_summary.order_id
)

select * from compute_booleans
