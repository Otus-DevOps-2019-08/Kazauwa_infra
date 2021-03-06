import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']
).get_hosts('all')


def test_mongo_running_and_enabled(host):
    mongo = host.service("mongod")
    assert mongo.is_running
    assert mongo.is_enabled


def test_config_file_contains_the_required_line(host):
    config_file = host.file('/etc/mongod.conf')
    assert config_file.contains('bindIp: 0.0.0.0')
    assert config_file.is_file


def test_mongo_port_is_listening(host):
    mongo_port = 27017
    local_mongo = host.addr('127.0.0.1')
    assert local_mongo.port(mongo_port).is_reachable
