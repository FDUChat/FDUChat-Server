require 'json'

module Success

  def self.__basic_success(no, text)
    JSON.generate({"id"=>no, "content"=>text})
  end

  module UserOPs

    def self.login_success
      Success.__basic_success(201, "login success")
    end

    def self.register_success
      Success.__basic_success(202, "register success")
    end

    def self.update_contacts_success
      Success.__basic_success(203, "contact updated")
    end

    def self.update_profile_success
      Success.__basic_success(204, "profile updated")
    end

  end

end
