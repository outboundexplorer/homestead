---
ip: "192.168.10.10"
memory: 2048
cpus: 1

authorize: ~/.ssh/id_rsa.pub

keys:
    - ~/.ssh/id_rsa

folders:
    - map: ~/WorkRoom/projects
      to: /home/vagrant/projects

sites:
    - map: project-name                                 *modify*
      to: /home/vagrant/projects/project-name/public    *modify*
      database: homestead                               *modify*
                                                        *repeat for additional projects*

migrations:                                             *remove if no migrations*
    - migrate: project-name                             *remove/modify*
                                                        *repeat for additional projects*

seeds:                                                  *remove if no seeds*
    - seed: project-name                                *remove/modify*
                                                        *repeat for additional projects*

variables:
    - key: APP_ENV
      value: local

developer:                                              *remove if no projects*
    - project: project-name                             *remove/modify*
                                                        *repeat for additional projects*

elasticsearch:                                          *remove for non-installation (system-level)*


###Developer packages###
* barryvdh/laravel-ide-helper
('Barryvdh\LaravelIdeHelper\IdeHelperServiceProvider' add to 'providers')

* barryvdh/laravel-debugbar
('Barryvdh\Debugbar\ServiceProvider' add to 'providers')
('Debugbar'        => 'Barryvdh\Debugbar\Facade' add to 'aliases')

* phpunit/phpunit

* fzaninotto/faker

* elasticsearch/elasticsearch


###Issues###
* In the config.sh script: 'database' => 'homestead' replace with $DB, this is set at line 26 (BE CAREFUL!)