class APIResponse<T> {
  T data;
  bool error;
  String errorMessage;

  APIResponse({this.data, this.errorMessage, this.error=false});
}

/*
{
            "id": "1",
            "classe": "11",
            "aula": "5IA",
            "prenotato": false,
            "createDateTime": "2019-11-25T20:03:05.791472+00:00",
            "latestEditDateTime": null
        },
        {
            "id": "2",
            "classe": "5",
            "aula": "4AB",
            "prenotato": false,
            "createDateTime": "2019-11-25T20:03:05.791472+00:00",
            "latestEditDateTime": null
        },
        {
            "id": "3",
            "classe": "2",
            "aula": "5IC",
            "prenotato": false,
            "createDateTime": "2019-11-25T20:03:05.791472+00:00",
            "latestEditDateTime": null
        }
        */