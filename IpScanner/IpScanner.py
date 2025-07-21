import subprocess
import platform
import ipaddress
from concurrent.futures import ThreadPoolExecutor, as_completed
import re
import csv

def ping_ip(ip):
    param = '-n' if platform.system().lower() == 'windows' else '-c'
    command = ['ping', param, '1', ip]
    result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    output = result.stdout.lower()
    
    if platform.system().lower() == 'windows':
        return 'ttl=' in output
    else:
        return ('1 packets received' in output) or ('1 received' in output)

def get_netbios_name(ip):
    if platform.system().lower() != 'windows':
        return None  # NetBIOS lookup supported on Windows only here
    
    try:
        result = subprocess.run(['nbtstat', '-A', ip], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, timeout=3)
        output = result.stdout

        match = re.search(r'^\s*(\S+)\s+<00>\s+UNIQUE', output, re.MULTILINE)
        if match:
            return match.group(1)
    except Exception:
        return None
    return None

def ip_to_int(ip):
    return int(ipaddress.IPv4Address(ip))

def int_to_ip(num):
    return str(ipaddress.IPv4Address(num))

def scan_ip_range_multithreaded(start_ip, end_ip, max_workers=100):
    start_int = ip_to_int(start_ip)
    end_int = ip_to_int(end_ip)

    if start_int > end_int:
        print("Error: Start IP must be less than or equal to End IP.")
        return

    print(f"Scanning IP range from {start_ip} to {end_ip} with up to {max_workers} threads...")

    ips = [int_to_ip(ip_int) for ip_int in range(start_int, end_int + 1)]
    results = []

    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        future_to_ip = {executor.submit(ping_and_get_netbios, ip): ip for ip in ips}
        for future in as_completed(future_to_ip):
            ip = future_to_ip[future]
            try:
                online, netbios = future.result()
                if online:
                    if netbios:
                        print(f"{ip} is online. NetBIOS: {netbios}")
                        results.append((ip, netbios))
                    else:
                        print(f"{ip} is online. NetBIOS: Not found")
                else:
                    print(f"{ip} is offline.")
            except Exception as exc:
                print(f"{ip} generated an exception: {exc}")

    if results:
        with open('netbios_results.csv', mode='w', newline='', encoding='utf-8') as csvfile:
            writer = csv.writer(csvfile)
            writer.writerow(['IP Address', 'NetBIOS Name'])
            writer.writerows(results)
        print(f"\nNetBIOS results saved to netbios_results.csv")
    else:
        print("\nNo NetBIOS names found in the scanned range.")

def ping_and_get_netbios(ip):
    online = ping_ip(ip)
    netbios = get_netbios_name(ip) if online else None
    return online, netbios

if __name__ == "__main__":
    start_ip = input("Enter start IP address (e.g. 172.23.0.1): ")
    end_ip = input("Enter end IP address (e.g. 172.23.13.254): ")
    scan_ip_range_multithreaded(start_ip, end_ip)
