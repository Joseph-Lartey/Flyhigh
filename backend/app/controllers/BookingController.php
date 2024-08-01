<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../models/Flight.php';

class BookingController {
    private $db;
    private $flight;

    public function __construct() {
        $database = new Database();
        $this->db = $database->getPdo();
        $this->flight = new Flight($this->db);
    }

    public function searchFlights($data) {
        $departure_country_id = $data['departure_country_id'];
        $arrival_country_id = $data['arrival_country_id'];
        $departure_date = $data['departure_date'];
        $flexible_days = isset($data['flexible_days']) ? $data['flexible_days'] : 7;

        $flights = $this->flight->searchFlights($departure_country_id, $arrival_country_id, $departure_date, $flexible_days);

        return $flights;
    }

    public function bookFlight($data) {
        $user_id = $data['user_id'];
        $flight_id = $data['flight_id'];
        $class_id = $data['class_id'];
        $num_people = $data['num_people'];
        $weight = $data['weight'];

        if ($this->flight->bookFlight($user_id, $flight_id, $class_id, $num_people, $weight)) {
            if ($this->flight->updateSeatAvailability($flight_id, $class_id, $num_people)) {
                return array("message" => "Booking successful.");
            }
            return array("message" => "Booking successful, but failed to update seat availability.");
        }

        return array("message" => "Booking failed.");
    }
}
?>