{{config(materialized = 'table')}}
with cte as (
    select REGEXP_EXTRACT(rma_no,'[a-zA-Z0-9-]+_([a-zA-Z0-9-]+)_[a-zA-Z0-9-]+') as rma_no,
        warehouse,
        originating_wh,
        item_no,
        item_description,
        return_status,
        upc,
        receipt_date,
        DATE(receipt_date) as parsed_receipt_date,
        return_tracking_no,
        shipment_order_no,
        expected_qty,
        received_qty,
        product_condition,
        reason_code,
        return_reason,
        lp_no,
        site_id,
        notes

        from {{ref("stg_test_schema__test_table")}}
)
select * from cte