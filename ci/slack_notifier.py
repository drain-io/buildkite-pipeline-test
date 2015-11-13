import httplib, json
import getopt, sys, os
import subprocess

def get_connection(organization):
  return httplib.HTTPSConnection('hooks.slack.com')

def get_url(token):
  return '/services/%s' % token

def get_data_from_git(format_string, commit):
  return subprocess.check_output(['git', 'log', '-1', '--format=format:%s' % format_string, commit])

def get_author(commit):
  return get_data_from_git('%an <%ae>', commit)

def get_date(commit):
  return get_data_from_git('%aD', commit)

def get_title(commit):
  return get_data_from_git('%s', commit)

def get_full_message(commit):
  return get_data_from_git('%b', commit)

def post_message(connection, url, success, project, status_text):
  headers = {'Content-Type': 'application/json'}
  build_url = os.environ['BUILD_URL']
  build_number = os.environ['BUILD_NUMBER']
  branch = os.environ['BRANCH']
  commit = os.environ['COMMIT']
  github = 'https://github.com/BlackBeltTechnology/judo/commit/'

  color = 'good' if success else 'danger'
  text = '<%s|Build #%s> %s for project %s on branch %s' % (build_url, build_number, status_text, project, branch)
  value = '<%s%s|%s> %s' % (github, commit, commit[0:7], get_full_message(commit))
  message = {
    'username': 'CI SERVER',
    'fallback': text,
    'pretext': text,
    'color': color,
    'fields': [
      {
        'title': get_author(commit),
        'value': get_date(commit)
      },
      {
        'title': get_title(commit),
        'value': value
      }
    ]
  }

  connection.request('POST', url, json.dumps(message), headers)
  response = connection.getresponse()
  print response.read().decode()

def main():
  try:
    opts, args = getopt.getopt(sys.argv[1:], ':sf', ['project=', 'org=', 'token=', 'statustext='])
  except getopt.GetoptError as err:
    print str(err)
    sys.exit(2)

  success = False
  project = None
  organization = None
  token = None
  statustext = 'FAILED'

  for o, arg in opts:
    if o == '-s':
      success = True
    elif o == '--project':
      project = arg
    elif o == '--org':
      organization = arg
    elif o == '--statustext':
      statustext = arg
    elif o == '--token':
      token = arg

  connection = get_connection(organization)
  url = get_url(token)
  post_message(connection, url, success, project, statustext)

if __name__ == '__main__':
  main()