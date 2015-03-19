{% from "salt/map.jinja" import salt_settings with context %}

python-pip:
  pkg.installed

pycrypto:
  pip.installed:
    - require:
      - pkg: python-pip

{% if grains['os_family'] not in ['Debian', 'RedHat'] %}
crypto:
  pip.installed:
    - require:
      - pkg: python-pip
{% endif %}

apache-libcloud:
  pip.installed:
    - name: git+https://github.com/apache/libcloud.git
    - require:
      - pkg: python-pip

{% for folder in salt_settings.cloud.folders %}
{{ folder }}:
  file.directory:
    - name: /etc/salt/{{ folder }}
    - user: root
    - group: root
    - file_mode: 744
    - dir_mode: 755
    - makedirs: True
{% endfor %}

{% for cert in salt['pillar.get']('salt_cloud_certs', {}) %}
cloud-cert-{{ cert }}-pem:
  file.managed:
    - name: /etc/salt/cloud.providers.d/key/{{ cert }}.pem
    - source: salt://salt/files/key
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - defaults:
        key: {{ cert }}
        type: pem
{% endfor %}

{% for providers in salt_settings.cloud.providers %}
salt-cloud-profiles-{{ providers }}:
  file.managed:
    - name: /etc/salt/cloud.profiles.d/{{ providers }}.conf
    - template: jinja
    - source: salt://salt/files/cloud.profiles.d/{{ providers }}.conf

salt-cloud-providers-{{ providers }}:
  file.managed:
    - name: /etc/salt/cloud.providers.d/{{ providers }}.conf
    - template: jinja
    - source: salt://salt/files/cloud.providers.d/{{ providers }}.conf

salt-cloud-maps-{{ providers }}:
  file.managed:
    - name: /etc/salt/cloud.maps.d/{{ providers }}.conf
    - template: jinja
    - source: salt://salt/files/cloud.maps.d/{{ providers }}.conf
{% endfor %}

/etc/cloud/google_compute_engine:
  file.managed:
    - name: /etc/cloud/google_compute_engine
    - template: jinja
    - source: salt://salt/files/key.prv
    - mode: 600
