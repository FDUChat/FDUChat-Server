require 'json'

module Error

  def self.__basic_error(no, text)
    JSON.generate({"id"=>no, "content"=>text})
  end

  def self.json_fault()
    Error.__basic_error(400, "Json is not valid")
  end

  module UserOPs

    def self.user_exists
      Error.__basic_error(401, "User already exists.")
    end

    def self.passwd_missed
      Error.__basic_error(402, "Password missed")
    end

    def self.no_user
      Error.__basic_error(403, "No such user.")
    end

    def self.error_passwd
      Error.__basic_error(404, "Wrong password")
    end

    def self.cannot_edit
      Error.__basic_error(405, "This field cannot be modified")
    end

    def self.update_failed
      Error.__basic_error(406, "Update user profile failed")
    end

  end

end
