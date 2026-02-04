with 

source as (

    select * from {{ source('test_schema', 'test_table') }}

),

renamed as (

    select
        rma_no,
        warehouse,
        originating_wh,
        return_status,
        item_no,
        item_description,
        upc,
        receipt_date,
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

    from source

)

select * from renamed