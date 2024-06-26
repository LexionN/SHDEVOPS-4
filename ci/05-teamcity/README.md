# Домашнее задание к занятию 11 «Teamcity»

## Подготовка к выполнению

1. В Yandex Cloud создайте новый инстанс (4CPU4RAM) на основе образа `jetbrains/teamcity-server`.
2. Дождитесь запуска teamcity, выполните первоначальную настройку.
3. Создайте ещё один инстанс (2CPU4RAM) на основе образа `jetbrains/teamcity-agent`. Пропишите к нему переменную окружения `SERVER_URL: "http://<teamcity_url>:8111"`.
4. Авторизуйте агент.
5. Сделайте fork [репозитория](https://github.com/aragastmatb/example-teamcity).
6. Создайте VM (2CPU4RAM) и запустите [playbook](./infrastructure).

   ![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/2d25b562-4d39-45a6-a137-02bf429f0661)

   ![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/48329d25-3e87-4391-ac56-528ecd09be9f)

<details>
<summary>ansible-playbook</summary>

   ansible-playbook -i inventory/cicd/hosts.yml site.yml 


PLAY [Get Nexus installed] *************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************
ok: [nexus-01]

TASK [Create Nexus group] **************************************************************************************************************************
changed: [nexus-01]

TASK [Create Nexus user] ***************************************************************************************************************************
changed: [nexus-01]

TASK [Install JDK] *********************************************************************************************************************************
changed: [nexus-01]

TASK [Create Nexus directories] ********************************************************************************************************************
changed: [nexus-01] => (item=/home/nexus/log)
changed: [nexus-01] => (item=/home/nexus/sonatype-work/nexus3)
changed: [nexus-01] => (item=/home/nexus/sonatype-work/nexus3/etc)
changed: [nexus-01] => (item=/home/nexus/pkg)
changed: [nexus-01] => (item=/home/nexus/tmp)

TASK [Download Nexus] ******************************************************************************************************************************
[WARNING]: Module remote_tmp /home/nexus/.ansible/tmp did not exist and was created with a mode of 0700, this may cause issues when running as
another user. To avoid this, create the remote_tmp dir with the correct permissions manually
changed: [nexus-01]

TASK [Unpack Nexus] ********************************************************************************************************************************
changed: [nexus-01]

TASK [Link to Nexus Directory] *********************************************************************************************************************
changed: [nexus-01]

TASK [Add NEXUS_HOME for Nexus user] ***************************************************************************************************************
changed: [nexus-01]

TASK [Add run_as_user to Nexus.rc] *****************************************************************************************************************
changed: [nexus-01]

TASK [Raise nofile limit for Nexus user] ***********************************************************************************************************
changed: [nexus-01]

TASK [Create Nexus service for SystemD] ************************************************************************************************************
changed: [nexus-01]

TASK [Ensure Nexus service is enabled for SystemD] *************************************************************************************************
changed: [nexus-01]

TASK [Create Nexus vmoptions] **********************************************************************************************************************
changed: [nexus-01]

TASK [Create Nexus properties] *********************************************************************************************************************
changed: [nexus-01]

TASK [Lower Nexus disk space threshold] ************************************************************************************************************
skipping: [nexus-01]

TASK [Start Nexus service if enabled] **************************************************************************************************************
changed: [nexus-01]

TASK [Ensure Nexus service is restarted] ***********************************************************************************************************
skipping: [nexus-01]

TASK [Wait for Nexus port if started] **************************************************************************************************************
ok: [nexus-01]

PLAY RECAP *****************************************************************************************************************************************
nexus-01                   : ok=17   changed=15   unreachable=0    failed=0    skipped=2    rescued=0    ignored=0 

</details>



## Основная часть

1. Создайте новый проект в teamcity на основе fork.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/728cf296-d084-487b-9d6b-6e573d4307b6)

2. Сделайте autodetect конфигурации.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/b6140c8d-0339-4486-86ee-1ffbeb84da37)

3. Сохраните необходимые шаги, запустите первую сборку master.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/d3b9b9ba-8ca9-4a16-a46a-f417008a105a)

4. Поменяйте условия сборки: если сборка по ветке `master`, то должен происходит `mvn clean deploy`, иначе `mvn clean test`.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/8fb402bc-39a4-428e-9598-2967121a6bb3)

5. Для deploy будет необходимо загрузить [settings.xml](./teamcity/settings.xml) в набор конфигураций maven у teamcity, предварительно записав туда креды для подключения к nexus.



6. В pom.xml необходимо поменять ссылки на репозиторий и nexus.
7. Запустите сборку по master, убедитесь, что всё прошло успешно и артефакт появился в nexus.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/78a2cfc5-1737-49cf-a9a9-cb6f84bd5b4f)

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/56388cf4-cf1a-4dc5-9cb4-9608d71ffe3b)

8. Мигрируйте `build configuration` в репозиторий.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/17359fe8-68b2-4f36-85cf-a6d1af60424f)

9. Создайте отдельную ветку `feature/add_reply` в репозитории.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/784639ef-70ed-4142-8734-17c24a1fd07e)

10. Напишите новый метод для класса Welcomer: метод должен возвращать произвольную реплику, содержащую слово `hunter`.

```
public String sayHunter(){
                return "Hello hunter!";
        }
```

11. Дополните тест для нового метода на поиск слова `hunter` в новой реплике.

```
 @Test
	public void netologySaysHunter() {
		assertThat(welcomer.sayHunter(), containsString("hunter"));
	}
```

12. Сделайте push всех изменений в новую ветку репозитория.
13. Убедитесь, что сборка самостоятельно запустилась, тесты прошли успешно.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/304df08f-85d2-440f-a380-6a3d61b344b5)

14. Внесите изменения из произвольной ветки `feature/add_reply` в `master` через `Merge`.
15. Убедитесь, что нет собранного артефакта в сборке по ветке `master`.
16. Настройте конфигурацию так, чтобы она собирала `.jar` в артефакты сборки.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/c0ed896d-f8fd-43ce-86bb-fcad975e7d3e)

17. Проведите повторную сборку мастера, убедитесь, что сбора прошла успешно и артефакты собраны.

![image](https://github.com/LexionN/SHDEVOPS-4/assets/124770915/66972df4-b49d-480e-94eb-aed8338d586e)

18. Проверьте, что конфигурация в репозитории содержит все настройки конфигурации из teamcity.
19. В ответе пришлите ссылку на репозиторий.

[example-teamcity](https://github.com/LexionN/example-teamcity/tree/master)

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
