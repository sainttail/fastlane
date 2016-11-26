describe PEM do
  describe PEM::Manager do
    before do
      ENV["DELIVER_USER"] = "test@fastlane.tools"
      ENV["DELIVER_PASSWORD"] = "123"

      stub_spaceship
    end

    before :all do
      FileUtils.mkdir("tmp")
    end

    it "Successful run" do
      options = { app_identifier: "com.krausefx.app", generate_p12: false }
      PEM.config = FastlaneCore::Configuration.create(PEM::Options.available_options, options)
      PEM::Manager.start

      expect(File.exist?("production_com.krausefx.app.pem")).to eq(true)
      expect(File.exist?("production_com.krausefx.app.pkey")).to eq(true)
    end

    it "Successful run with development option" do
      options = { app_identifier: "com.krausefx.app.development", generate_p12: false, development: true, voip: true }
      PEM.config = FastlaneCore::Configuration.create(PEM::Options.available_options, options)
      PEM::Manager.start

      expect(File.exist?("development_com.krausefx.app.development.pem")).to eq(true)
      expect(File.exist?("development_com.krausefx.app.development.pkey")).to eq(true)
    end

    it "Successful run with voip option" do
      options = { app_identifier: "com.krausefx.app.voip", generate_p12: false, voip: true }
      PEM.config = FastlaneCore::Configuration.create(PEM::Options.available_options, options)
      PEM::Manager.start

      expect(File.exist?("production_com.krausefx.app.voip.pem")).to eq(true)
      expect(File.exist?("production_com.krausefx.app.voip.pkey")).to eq(true)
    end

    it "Successful run with output_path" do
      options = { app_identifier: "com.krausefx.app", generate_p12: false, output_path: "tmp/" }
      PEM.config = FastlaneCore::Configuration.create(PEM::Options.available_options, options)
      PEM::Manager.start

      expect(File.exist?("tmp/production_com.krausefx.app.pem")).to eq(true)
      expect(File.exist?("tmp/production_com.krausefx.app.pkey")).to eq(true)
      expect(File.exist?("tmp/production_com.krausefx.app.p12")).to eq(false)
    end

    after :all do
      FileUtils.rm_r("tmp")
      File.delete("development_com.krausefx.app.development.pem")
      File.delete("development_com.krausefx.app.development.pkey")
      File.delete("production_com.krausefx.app.voip.pem")
      File.delete("production_com.krausefx.app.voip.pkey")
      File.delete("production_com.krausefx.app.pem")
      File.delete("production_com.krausefx.app.pkey")

      ENV.delete("DELIVER_USER")
      ENV.delete("DELIVER_PASSWORD")
    end
  end
end
