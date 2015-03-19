{% from "salt/map.jinja" import salt_settings with context %}

salt-minion:
  file.recurse:
    - name: {{ salt_settings.config_path }}/minion.d
    - template: jinja
    - source: salt://salt/files/minion.d
    - clean: True
    - context:
        standalone: True
  service.dead:
    - enable: False
    - name: {{ salt_settings.minion_service }}
    - require:
      - file: salt-minion
