
# NSTU Sportify System 🏆

A sports management system built to manage events, teams, matches, and tournament results for NSTU. The project integrates a **Django backend** and a **Flutter frontend** for an interactive user experience.

---

## 📖 Project Description
The **NSTU Sportify System** provides a platform to:
- Manage teams, players, matches, and tournaments.
- Enable role-based access control for admins, representatives, and general users.
- View past tournament winners, team details, and match schedules.
- Handle representative requests for approval/rejection by the admin.

The project adheres to RESTful API principles, enabling a seamless connection between the backend and frontend.

---

## ⚙️ Configuration and Setup

### Prerequisites
- Python 3.10+
- Flutter 3.0+
- MySQL Server (XAMPP for local hosting)
- Django 4.x
- Dart SDK
- IDE/Text Editor: PyCharm, Visual Studio Code, or any preferred editor.

### Backend (Django) Setup
1. **Clone the Repository**
   ```bash
   git clone https://github.com/your-username/nstu-sportify.git
   cd nstu-sportify/backend
   ```

2. **Create a Virtual Environment**
   ```bash
   python -m venv venv
   source venv/bin/activate  # For Windows: venv\Scripts\activate
   ```

3. **Install Dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Database Configuration**
   Update the `DATABASES` section in `nstu_sportify/settings.py` to match your MySQL setup.
   ```python
   DATABASES = {
       'default': {
           'ENGINE': 'django.db.backends.mysql',
           'NAME': 'your_db_name',
           'USER': 'your_db_user',
           'PASSWORD': 'your_db_password',
           'HOST': '127.0.0.1',
           'PORT': '3306',
       }
   }
   ```

5. **Apply Migrations**
   ```bash
   python manage.py makemigrations
   python manage.py migrate --fake
   ```

6. **Run the Development Server**
   ```bash
   python manage.py runserver
   ```
   The backend will be accessible at [http://127.0.0.1:8000/](http://127.0.0.1:8000/).

### Frontend (Flutter) Setup
1. **Navigate to the Frontend Directory**
   ```bash
   cd ../frontend
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the Flutter App**
   ```bash
   flutter run
   ```

---

## 🎥 Links to Presentations
- **[Project Presentation](NSTU_Sportify.pptx)**
- **[SRS Docuement](NSTU_Sportify_SRS.pdf)**

---

## 📂 Project Structure

### Backend
- `models.py`: Defines data models (Team, Player, Matchdetails, etc.).
- `views.py`: Contains logic for handling requests and responses.
- `urls.py`: Maps endpoints to their respective views.
- `serializers.py`: Converts data between models and JSON.

### Frontend
- `lib/`: Contains Flutter code.
- `main.dart`: Entry point of the Flutter app.
- `Screens/`: UI pages like Admin Dashboard, Team Management, etc.
- `api_services/`: Handles HTTP requests to the backend.
- `models.py`: Defines data models (Team, Player, Matchdetails, etc.).

---

## 🤝 Contributing
Contributions are welcome! Feel free to submit issues or pull requests to enhance the project.

---

## 💡 Credits
Developed by Mohammed Maruf Islam,Mission Devnath and Al Shahriar Shafi.
