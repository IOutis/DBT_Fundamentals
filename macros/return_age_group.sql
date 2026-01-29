{%macro age_group(age)%}
    case when {{age}} > 0 and {{age}} < 30 then 'Young'
        when {{age}} >30 and {{age}} < 60 then 'Adult'
        when {{age}} > 60 then 'Senior'
        else 'invalid'
    END
{%endmacro%}