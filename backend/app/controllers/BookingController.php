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
        $template_id = $data['template_id'];
        $departure_country_id = $data['departure_country_id'];
        $arrival_country_id = $data['arrival_country_id'];

        if ($this->flight->bookFlight($user_id, $template_id, $departure_country_id, $arrival_country_id)) {
            return array("message" => "Booking successful.");
        }

        return array("message" => "Booking failed.");
    }

    public function getUserBookings($user_id) {
        return $this->flight->getUserBookings($user_id);
    }
}    
?>
