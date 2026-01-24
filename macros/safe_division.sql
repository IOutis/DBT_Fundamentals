{%macro calculate_margin(numerator,denominator)%}
    case
        when {{ numerator }} = 0 then 0
        else ( ({{ numerator }} - {{ denominator }}) / {{ numerator }} ) * 100
    end
{%endmacro%}