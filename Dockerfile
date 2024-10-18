# Base image: Use Ruby version 3.1.2 as the foundation for this Docker image
FROM ruby:3.1.2

# Update the package list and install required system packages:
# - build-essential: Provides necessary tools for building software (like compilers)
# - libsqlite3-dev: Development files for SQLite3, which is needed for the SQLite3 gem
# - nodejs: Required for Rails asset pipeline (JavaScript runtime)
RUN apt-get update -qq && apt-get install -y build-essential libsqlite3-dev nodejs

# Set the working directory inside the container to /myapp
# This is where all the application code will reside
WORKDIR /myapp

# Copy the Gemfile and Gemfile.lock into the working directory
# These files specify the Ruby gems required for the application
COPY Gemfile Gemfile.lock ./

# Install all the required Ruby gems defined in the Gemfile
# This step includes both runtime and development dependencies
RUN bundle install

# Copy the rest of the application code from the current directory on the host to the working directory in the container
COPY . .

# Uncomment the following lines if you want to switch to a non-root user
# Change ownership of all files in /myapp to 'appuser:appgroup'
# This helps in following the principle of least privilege
#RUN chown -R appuser:appgroup /myapp
# Ensure the correct permissions for the application files
#RUN chmod -R 755 /myapp  

# Uncomment this line to switch to a non-root user before running the application
#USER appuser

# Expose port 3000 to the outside world
# This allows access to the Rails application running on this port
EXPOSE 3000

# Define the command to run when the container starts:
# Use 'rerun' to automatically restart the Rails server on code changes
# 'bundle exec' ensures that the command runs with the gems specified in the Gemfile
CMD ["rails", "server", "-b", "0.0.0.0"]

