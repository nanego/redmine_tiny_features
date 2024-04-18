# Redmine Tiny Features

This plugin adds some small features we are testing and plan to commit to Redmine core if validated.

Here is a complete list of the features:
* Make it possible to disable **custom field values** per project (only for key/value lists)
* Display a warning message when a user is editing a **closed issue**, and automatically re-open the edited issue
* Hide optional advanced fields in **version** form
* Define a **default project** selected when creating a new issue without being in a specific project
* Add **check-all / uncheck-all shortcuts** to roles filters
* Improve **roles synthesis** by adding missing data about issues permissions and trackers
* Use or not the select2 plugin
* Improve load time of **users filters** when there are thousands entries and when the select2 plugin is used
* Save **note deletion** in issue journal
* Fix **pasted images** when using Chrome (may be fixed in future Redmine versions according to this issue https://www.redmine.org/issues/36013)
* **Reminders rake task: add max-delay option** to define the maximum number of days after which reminders stop to be sent
* Add **range** custom-field format
* Apply **default value** to existing-issues custom-fields if field is required and not set
* Add **enabled modules** filter and column in projects list
* Add **prevent issue copy** attribute to trackers
* Add new permission to always see **users's email addresses**, bypassing user email_hiding setting
* Add an option to **load issue form asynchronously** and reduce issue#show load time
* Add customizable **issue colorization** based on status or priority
* Add a user parameter to also **display pagination links at the top of issues results**
* Include the 'notes' field in workflows, providing the capability to **require notes** when updating an issue
* Issues filter: **sort group-by options alphabetically**
* PDF exports: add **links to attached files in generated PDF**"
* Projects overview: add an option to **hide members section**

## Test status

| Plugin branch | Redmine Version | Test Status       |
|---------------|-----------------|-------------------|
| master        | 4.2.11          | [![4.2.11][1]][5] |
| master        | 5.1.2           | [![5.1.2][2]][5]  |
| master        | master          | [![master][3]][5] |

[1]: https://github.com/nanego/redmine_tiny_features/actions/workflows/4_2_11.yml/badge.svg
[2]: https://github.com/nanego/redmine_tiny_features/actions/workflows/5_1_2.yml/badge.svg
[3]: https://github.com/nanego/redmine_tiny_features/actions/workflows/master.yml/badge.svg
[5]: https://github.com/nanego/redmine_tiny_features/actions
