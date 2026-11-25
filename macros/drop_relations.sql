{% macro drop_relation(schema_name, relation_name, relation_type='table') %}

    {% set sql %}
        drop {{ relation_type }} if exists {{ target.database }}.{{ schema_name }}.{{ relation_name }}
    {% endset %}

    {% do run_query(sql) %}
    {{ log("Eliminado: " ~ schema_name ~ "." ~ relation_name, info=True) }}

{% endmacro %}