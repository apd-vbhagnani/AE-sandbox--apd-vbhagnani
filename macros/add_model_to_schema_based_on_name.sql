{% macro add_model_to_schema_based_on_name(model_name) %}
  {% if model_name.startswith('hub') %}
    {% set schema_name = 'HUB' %}
  {% elif model_name.startswith('satellite') %}
    {% set schema_name = 'satellite' %}
  {% elif model_name.startswith('link') %}
    {% set schema_name = 'link' %}
  {% else %}
    {% set schema_name = 'hub' %}  {# Default to 'hub' if no match #}
  {% endif %}
  
  -- Return the full schema and model name
  {{ return(schema_name ~ '.' ~ model_name) }}
{% endmacro %}
