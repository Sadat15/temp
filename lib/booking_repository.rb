require "booking"
require "database_connection"



class BookingRepository

  def to_boolean(str)
    return true if str == 't'
    return false if str == 'f'
  end
  
  def find_by_user_id(user_id)
    sql = 'SELECT * FROM bookings WHERE user_id = $1;'
    sql_params = [user_id]
    result_set = DatabaseConnection.exec_params(sql, sql_params)
    all_bookings = []
    result_set.each do |record|
      booking = Booking.new
      booking.id = record['id']
      booking.user_id = record['user_id']
      booking.space_id = record['space_id']
      booking.date = record['date']
      booking.confirmed = to_boolean(record['confirmed'])

      all_bookings << booking
    end
    return all_bookings
  end
  def find_by_space_id(space_id)
    sql = 'SELECT * FROM bookings WHERE space_id = $1;'
    sql_params = [space_id]
    result_set = DatabaseConnection.exec_params(sql, sql_params)
    all_bookings = []
    result_set.each do |record|
      booking = Booking.new
      booking.id = record['id']
      booking.user_id = record['user_id']
      booking.space_id = record['space_id']
      booking.date = record['date']
      booking.confirmed = to_boolean(record['confirmed'])

      all_bookings << booking
    end
    return all_bookings
  end

  def create(booking)
    sql = 'INSERT INTO bookings (user_id, space_id, date, confirmed) VALUES ($1, $2, $3, $4);'
    sql_params = [booking.user_id, booking.space_id, booking.date, false]
    DatabaseConnection.exec_params(sql, sql_params)
    return nil
  end
end