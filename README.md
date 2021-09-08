# Redmine Tiny Features

This plugin adds some small features we are testing and plan to commit to Redmine core if validated.

Here is a complete list of the features:
* Make it possible to disable **custom field values** per project (only for key/value lists)
* Display a warning message when a user is editing a **closed issue**, and automatically re-open the edited issue
* Hide optional advanced fields in **version** form
* Define a **default project** selected when creating a new issue without being in a specific project
* Add **check-all / uncheck-all shortcuts** to roles filters
* Improve **roles synthesis** by adding missing informations about issues permissions and trackers

## Test status

|Plugin branch| Redmine Version   | Test Status      |
|-------------|-------------------|------------------|
|master       | 4.2.2             | [![4.2.2][1]][5] | 
|master       | 4.1.4             | [![4.1.4][2]][5] | 
|master       | master            | [![master][3]][5]|

[1]: https://github.com/nanego/redmine_tiny_features/actions/workflows/4_2_2.yml/badge.svg
[2]: https://github.com/nanego/redmine_tiny_features/actions/workflows/4_1_4.yml/badge.svg
[3]: https://github.com/nanego/redmine_tiny_features/actions/workflows/master.yml/badge.svg
[5]: https://github.com/nanego/redmine_tiny_features/actions
