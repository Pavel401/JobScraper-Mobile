# JobHunt Mobile

JobHunt Mobile is a companion mobile application designed to enhance the user experience of the Jobs Scraper project. This mobile app provides a convenient interface for job seekers to access and manage job postings scraped by the Jobs Scraper. With JobHunt Mobile, users can browse, search, and filter job opportunities on the go.

Original Repo :[ https://github.com/Pavel401/JobScraper-Mobile](https://github.com/Pavel401/Jobs-Scraper)


## Usage & Screenshots

<img src='https://github.com/Pavel401/JobScraper-Mobile/assets/47685150/402a9939-aed2-473a-98e2-e5b42741fbf6' width=200></img> 
<img src='https://github.com/Pavel401/JobScraper-Mobile/assets/47685150/191e1eb1-5bbd-46be-8ce7-ca01596c62bd' width=200></img> 
<img src='https://github.com/Pavel401/JobScraper-Mobile/assets/47685150/31dcdc1f-276c-4117-ab08-fda3af0ab513' width=200></img> 
<img src='https://github.com/Pavel401/JobScraper-Mobile/assets/47685150/fb2d30c1-34f9-4633-aa2c-20f0b2151115' width=200></img> 

<img src='https://github.com/Pavel401/JobScraper-Mobile/assets/47685150/ac2812ac-f0c7-4d94-ad92-2d891fb0b749' width=200></img> 
<img src='https://github.com/Pavel401/JobScraper-Mobile/assets/47685150/1e76aea2-33a4-4b4d-b4ac-b1f7681bcff8' width=200></img> 
<img src='https://github.com/Pavel401/JobScraper-Mobile/assets/47685150/ec10ad49-579d-4246-a15e-1715e32a1f47' width=200></img> 
<img src='https://github.com/Pavel401/JobScraper-Mobile/assets/47685150/f0032f36-f7bb-477b-8f22-e031c6bf58eb' width=200></img> 


## Features

- **User-Friendly Interface:** Enjoy a sleek and intuitive mobile interface for easy navigation.
- **Search and Filter:** Quickly find relevant job postings by using advanced search and filtering options.
- **Offline first** Stores the jobs data in the SQLite db to decrease the number of API calls.
- **Real-time Updates:** Stay up-to-date with the latest job opportunities as the app synchronizes with the Jobs Scraper's database.



## Installation

1. Download the JobHunt Mobile app from the release tab.
2. Install the app on your mobile device.

## Configuration

To run the application, you have to create a `.env` file. To configure you can set environment variables in the file. 
Also, make sure you are running the JobScraper locally.

```env
JOB_API=http://10.0.2.2:8080/getallJobsFromSQL
```

## Contributing

Contributions to this project are highly encouraged! If you have ideas for improvements or come across any issues, please don't hesitate to open an issue or submit a pull request on the [GitHub repository](https://github.com/Pavel401/JobScraper-Mobile).

## License

This project is licensed under the [GPL-3.0 license] License - see the [LICENSE](LICENSE) file for details.

---

## To-Do List

- **Push Notifications:** Enable push notifications to alert users about new job opportunities matching their criteria.
- **User Accounts:** Introduce user accounts to allow personalized job tracking and saving.
- **Feedback Mechanism:** Incorporate a feedback system for users to report issues or provide suggestions directly through the app.

## Backend
Visit https://github.com/Pavel401/Jobs-Scraper
