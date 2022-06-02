# Redmine Tiny Features

This plugin adds some small features we are testing and plan to commit to Redmine core if validated.

Here is a complete list of the features:
* Make it possible to disable **custom field values** per project (only for key/value lists)
* Display a warning message when a user is editing a **closed issue**, and automatically re-open the edited issue
* Hide optional advanced fields in **version** form
* Define a **default project** selected when creating a new issue without being in a specific project
* Add **check-all / uncheck-all shortcuts** to roles filters
* Improve **roles synthesis** by adding missing informations about issues permissions and trackers
* Use or not the select2 plugin
* Improve load time of **users filters** when there are thousands entries and when the select2 plugin is used
* Save **note deletion** in issue journal
* Fix **pasted images** when using Chrome (may be fixed in future Redmine versions according to this issue https://www.redmine.org/issues/36013)
* **Reminders rake task: add max-delay option** to define the maximum number of days after which reminders stop to be sent
* Add **range** custom-field format

## Test status

|Plugin branch| Redmine Version   | Test Status      |
|-------------|-------------------|------------------|
|master       | 4.2.5             | [![4.2.5][1]][5] | 
|master       | 4.1.7             | [![4.1.7][2]][5] | 
|master       | master            | [![master][3]][5]|

[1]: https://github.com/nanego/redmine_tiny_features/actions/workflows/4_2_5.yml/badge.svg
[2]: https://github.com/nanego/redmine_tiny_features/actions/workflows/4_1_7.yml/badge.svg
[3]: https://github.com/nanego/redmine_tiny_features/actions/workflows/master.yml/badge.svg
[5]: https://github.com/nanego/redmine_tiny_features/actions
