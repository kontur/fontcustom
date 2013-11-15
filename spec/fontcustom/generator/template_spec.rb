require "spec_helper"

describe Fontcustom::Generator::Template do
  context "#generate" do
    it "should generate templates (integration)", :integration => true do
      live_test do |testdir|
        FileUtils.cp_r fixture("generators/mixed-output"), "fontcustom"
        manifest = test_manifest(
          :input => "vectors", 
          :quiet => true,
          :templates => %w|preview css scss scss-rails bootstrap bootstrap-scss bootstrap-ie7 bootstrap-ie7-scss|
        )
        Fontcustom::Generator::Font.new(manifest).generate
        gen = Fontcustom::Generator::Template.new manifest

        gen.generate
      end
    end
  end

  context ".set_relative_paths" do
    it "should assign @font_path, @font_path_alt, and @font_path_preview" do
      gen = Fontcustom::Generator::Template.new fixture("generators/.fontcustom-manifest.json")
      options = gen.instance_variable_get :@options
      options[:output] = {:fonts => fixture("foo/fonts"), :css => fixture("output/css"), :preview => fixture("views/")}

      gen.send :set_relative_paths
      gen.instance_variable_get(:@font_path).should match("../../foo/fonts")
      gen.instance_variable_get(:@font_path_alt).should match("../../foo/fonts")
      gen.instance_variable_get(:@font_path_preview).should match("../foo/fonts")
    end

    it "should assign @font_path_alt if :preprocessor_font_path is set" do
      gen = Fontcustom::Generator::Template.new fixture("generators/.fontcustom-manifest.json")
      options = gen.instance_variable_get :@options
      options[:preprocessor_font_path] = "fonts/fontcustom"
      options[:output] = {:fonts => fixture("foo/fonts"), :css => fixture("output/css"), :preview => fixture("views/")}

      gen.send :set_relative_paths
      gen.instance_variable_get(:@font_path_alt).should match("fonts/fontcustom")
    end

    it "should assign '.' when paths are the same" do
      gen = Fontcustom::Generator::Template.new fixture("generators/.fontcustom-manifest.json")
      options = gen.instance_variable_get :@options
      options[:output] = {:fonts => fixture("foo/fonts"), :css => fixture("foo/fonts"), :preview => fixture("foo/fonts")}

      gen.send :set_relative_paths
      gen.instance_variable_get(:@font_path).should match("./")
    end
  end
end
