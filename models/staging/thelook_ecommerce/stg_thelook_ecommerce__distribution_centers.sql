with 

source as (

    select * from {{ source('thelook_ecommerce', 'distribution_centers') }}

),

renamed as (

    select
        id as product_distribution_center_id,
        name as distribution_center_name,
        latitude as distribution_center_latitude,
        longitude as distribution_center_longitude,
        distribution_center_geom

    from source

)

select * from renamed